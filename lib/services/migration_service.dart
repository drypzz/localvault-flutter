import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class MigrationService {
  static const String _versionKey = 'app_data_version';
  static const int _targetVersion = 2;

  Future<void> runMigration() async {
    final prefs = await SharedPreferences.getInstance();
    int currentVersion = prefs.getInt(_versionKey) ?? 1; 

    if (currentVersion < _targetVersion) {
      if (kDebugMode) {
        print('Migrando dados da versão $currentVersion para $_targetVersion...');
      }
      // Aqui entraria a lógica de conversão de dados legados (v1 -> v2)
      await prefs.setInt(_versionKey, _targetVersion);
    }
  }
}