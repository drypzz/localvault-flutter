import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/settings_service.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _box = Hive.box<UserProfile>('profileBox');
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        nome: _nomeController.text,
        email: _emailController.text,
        dataCadastro: DateTime.now(),
        pontuacao: 150, // Bônus por engajamento!
      );
      _box.put('myProfile', profile);
      FocusScope.of(context).unfocus(); // Esconde o teclado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil salvo com sucesso!'), backgroundColor: Colors.green),
      );
      setState(() {}); 
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Atenção (LGPD)'),
        content: const Text('Deseja realmente apagar todos os seus dados locais? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteProfile();
            },
            child: const Text('Apagar Tudo', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteProfile() {
    _box.delete('myProfile');
    _nomeController.clear();
    _emailController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados apagados permanentemente.'), backgroundColor: Colors.red),
    );
    setState(() {}); 
  }
@override
  Widget build(BuildContext context) {
    final profile = _box.get('myProfile');
    // Escutando as configurações para o formulário
    final settings = context.watch<SettingsService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(settings.translate('Editar Perfil'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: settings.translate('Nome Completo'), border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.person)),
                      validator: (val) => val!.isEmpty ? settings.translate('Campo obrigatório') : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: settings.translate('E-mail'), border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.email)),
                      validator: (val) => val!.isEmpty || !val.contains('@') ? settings.translate('E-mail inválido') : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save),
                      label: Text(settings.translate('Salvar Alterações')),
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (profile != null) ...[
            Text(settings.translate('Seus Dados Locais'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${settings.translate('Nome')}: ${profile.nome}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('${settings.translate('E-mail')}: ${profile.email}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('${settings.translate('Cadastro')}: ${profile.dataCadastro.toString().split(' ')[0]}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: Text(settings.translate('Apagar Perfil (Direito ao Esquecimento)'), style: const TextStyle(color: Colors.red)),
            ),
          ] else
            Center(child: Text(settings.translate('Nenhum dado de perfil armazenado.'), style: const TextStyle(fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }
}