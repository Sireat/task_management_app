import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart'; // Ensure you have a provider for theme management

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            const SizedBox(height: 20),
            
            // Profile Section
            Text('Profile', style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: const Text('Edit Profile'),
              onTap: () {
                // Navigate to Profile Edit Screen
              },
            ),
            const SizedBox(height: 20),
            
            // Notifications Section
            Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: const Text('Manage Notifications'),
              onTap: () {
                // Navigate to Notification Settings Screen
              },
            ),
            const SizedBox(height: 20),
            
            // About Section
            Text('About', style: Theme.of(context).textTheme.titleLarge),
            const ListTile(
              title: Text('App Version'),
              subtitle: Text('1.0.0'),
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                // Navigate to Privacy Policy Screen
              },
            ),
            ListTile(
              title: const Text('Terms of Service'),
              onTap: () {
                // Navigate to Terms of Service Screen
              },
            ),
          ],
        ),
      ),
    );
  }
}