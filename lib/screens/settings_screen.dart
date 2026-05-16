import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ao usar watch, qualquer mudança no state refaz o build desta tela
    final settings = context.watch<SettingsService>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          settings.translate('Preferências Visuais'), 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                // Passando pelo tradutor!
                title: Text(settings.translate('Modo Escuro')),
                value: settings.isDarkMode,
                onChanged: settings.toggleTheme,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(settings.translate('Idioma')),
                trailing: DropdownButton<String>(
                  underline: const SizedBox(),
                  value: settings.language,
                  items: ['Português', 'Inglês'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) => settings.setLanguage(val!),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          settings.translate('Geral'), 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: Text(settings.translate('Ativar Notificações')),
            value: settings.notificationsEnabled,
            onChanged: settings.toggleNotifications,
          ),
        ),
      ],
    );
  }
}