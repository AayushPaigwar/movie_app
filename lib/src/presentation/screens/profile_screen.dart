import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0E0E0E),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Information',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.amber),
                  title: Text('User Name', style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text('John Doe', style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () {
                    // TODO: Edit profile
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.amber),
                  title: Text('Email', style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text('john.doe@example.com', style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () {
                    // TODO: Edit email
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'App Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.amber),
                  title: Text('Notifications', style: Theme.of(context).textTheme.titleSmall),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle notifications
                    },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.dark_mode, color: Colors.amber),
                  title: Text('Dark Mode', style: Theme.of(context).textTheme.titleSmall),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // TODO: Toggle dark mode
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
