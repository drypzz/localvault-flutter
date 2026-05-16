import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../services/storage_service.dart';
import '../services/settings_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  String _displayedToken = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  String _generateRandomToken() {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))
    ));
  }

  Future<void> _loadToken() async {
    final token = await _storageService.getToken();
    setState(() {
      _displayedToken = token ?? 'Nenhum token seguro salvo.';
    });
  }

  Future<void> _recoverToken() async {
    final settings = context.read<SettingsService>();
    
    setState(() {
      _displayedToken = settings.translate('Buscando...');
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final token = await _storageService.getToken();
    
    setState(() {
      _displayedToken = token ?? settings.translate('Nenhum token seguro salvo.');
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            token != null 
              ? settings.translate('Token recuperado com sucesso!') 
              : settings.translate('Nenhum token encontrado.')
          ),
          backgroundColor: token != null ? Colors.blue : Colors.red,
        ),
      );
    }
  }

  Future<void> _saveToken() async {
    final newToken = _generateRandomToken();
    await _storageService.saveToken(newToken);
    await _loadToken();
    
    if (mounted) {
      final settings = context.read<SettingsService>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(settings.translate('Novo token gerado e salvo!')), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _deleteToken() async {
    await _storageService.deleteToken();
    await _loadToken();
    
    if (mounted) {
      final settings = context.read<SettingsService>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(settings.translate('Token apagado com segurança.')), backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_outline, size: 80, color: Colors.indigo),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(settings.translate('Status do Token'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    _displayedToken.contains('Nenhum') || _displayedToken.contains('No secure') 
                        ? settings.translate('Nenhum token seguro salvo.') 
                        : _displayedToken,
                    style: TextStyle(
                      fontSize: 16, 
                      color: _displayedToken.contains('Nenhum') || _displayedToken.contains('No secure') ? Colors.red : Colors.green,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: _saveToken,
            icon: const Icon(Icons.vpn_key),
            label: Text(settings.translate('Gerar e Salvar Token')),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
          const SizedBox(height: 12),
          
          ElevatedButton.icon(
            onPressed: _recoverToken,
            icon: const Icon(Icons.download),
            label: Text(settings.translate('Recuperar Token')),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          
          OutlinedButton.icon(
            onPressed: _deleteToken,
            icon: const Icon(Icons.delete, color: Colors.red),
            label: Text(settings.translate('Deletar Token do Keystore'), style: const TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
        ],
      ),
    );
  }
}