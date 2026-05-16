import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  late SharedPreferences _prefs;
  
  bool _isDarkMode = false;
  String _language = 'Português';
  bool _notificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;

  String translate(String key) {
    if (_language == 'Português') return key;

    final Map<String, String> enUs = {
      // Menu / Abas
      'LocalVault': 'LocalVault',
      'Autenticação': 'Authentication',
      'Perfil': 'Profile',
      'Ajustes': 'Settings',
      
      // Tela de Configurações
      'Preferências Visuais': 'Visual Preferences',
      'Modo Escuro': 'Dark Mode',
      'Idioma': 'Language',
      'Geral': 'General',
      'Ativar Notificações': 'Enable Notifications',

      // Tela de Autenticação (Home)
      'Status do Token': 'Token Status',
      'Gerar e Salvar Token': 'Generate & Save Token',
      'Deletar Token do Keystore': 'Delete Token from Keystore',
      'Nenhum token seguro salvo.': 'No secure token saved.',
      'Carregando...': 'Loading...',
      'Recuperar Token': 'Recover Token',
      'Buscando...': 'Fetching...',
      'Token recuperado com sucesso!': 'Token successfully recovered!',
      'Nenhum token encontrado.': 'No token found.',
      
      // Tela de Perfil
      'Editar Perfil': 'Edit Profile',
      'Nome Completo': 'Full Name',
      'E-mail': 'E-mail',
      'Salvar Alterações': 'Save Changes',
      'Seus Dados Locais': 'Your Local Data',
      'Cadastro': 'Registered',
      'Apagar Perfil (Direito ao Esquecimento)': 'Delete Profile (Right to be Forgotten)',
      'Nenhum dado de perfil armazenado.': 'No profile data stored.',
      'Campo obrigatório': 'Required field',
      'E-mail inválido': 'Invalid e-mail',
      'Nome': 'Name',
    };

    return enUs[key] ?? key;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('darkMode') ?? false;
    _language = _prefs.getString('language') ?? 'Português';
    _notificationsEnabled = _prefs.getBool('notifications') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('darkMode', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool('notifications', value);
    notifyListeners();
  }
}