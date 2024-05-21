import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/task_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'services/api_service.dart';
import 'services/database.helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.tryAutoLogin();

  // Create instances of ApiService and DatabaseHelper
  final apiService = ApiService();
  final databaseHelper = DatabaseHelper();

  runApp(MyApp(authProvider: authProvider, apiService: apiService, databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final ApiService apiService;
  final DatabaseHelper databaseHelper;

  MyApp({required this.authProvider, required this.apiService, required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(apiService: apiService, databaseHelper: databaseHelper),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.user != null) {
                return TaskScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
          '/tasks': (context) => TaskScreen(),
        },
      ),
    );
  }
}
