import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/notification_service.dart';
import 'presentation/provider/app_provider.dart';
import 'presentation/provider/theme_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/add_edit_task_screen.dart';
import 'presentation/screens/completed_tasks_screen.dart';
import 'presentation/screens/settings_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize NotificationService
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(AppProvider(
    notificationService: notificationService,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Task Management App',
      theme: themeProvider.themeData, // Use theme from ThemeProvider
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/add_edit_task': (context) => AddEditTaskScreen(),
        '/completed_tasks': (context) => CompletedTasksScreen(),
        '/settings': (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
