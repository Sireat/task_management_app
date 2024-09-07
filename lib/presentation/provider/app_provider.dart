import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/quote_repository_impl.dart';
import 'task_provider.dart';
import 'quote_provider.dart';
import 'theme_provider.dart';

class AppProvider extends StatelessWidget {
  final Widget child;

  AppProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => TaskProvider(
                  taskRepository: TaskRepositoryImpl(
                    localDataSource: LocalDataSourceImpl(
                      sharedPreferences: snapshot.data as SharedPreferences,
                    ),
                  ),
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => QuoteProvider(
                  quoteRepository: QuoteRepositoryImpl(), // Provide the QuoteRepositoryImpl
                ),
              ),
              ChangeNotifierProvider(
                create: (_) => ThemeProvider(),
              ),
            ],
            child: child,
          );
        }
        return Center(child: CircularProgressIndicator()); // Show loading indicator
      },
    );
  }
}
