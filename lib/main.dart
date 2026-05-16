import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/user_profile.dart';
import 'services/settings_service.dart';
import 'services/migration_service.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter()); 
  await Hive.openBox<UserProfile>('profileBox');

  await MigrationService().runMigration();

  final settingsService = SettingsService();
  await settingsService.init();

  runApp(
    ChangeNotifierProvider.value(
      value: settingsService,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    
    return MaterialApp(
      title: 'LocalVault',
      debugShowCheckedModeBanner: false,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainTabController(),
    );
  }
}

class MainTabController extends StatelessWidget {
  const MainTabController({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(settings.translate('LocalVault'), style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.security), text: settings.translate('Autenticação')),
              Tab(icon: const Icon(Icons.person), text: settings.translate('Perfil')),
              Tab(icon: const Icon(Icons.settings), text: settings.translate('Ajustes')),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),      
            ProfileScreen(),   
            SettingsScreen(),  
          ],
        ),
      ),
    );
  }
}