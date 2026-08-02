import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;

  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        children: [
          SwitchListTile(
            value: darkMode,
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),

          SwitchListTile(
            value: notifications,
            title: const Text("Notifications"),
            secondary: const Icon(Icons.notifications),
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          const ListTile(
            leading: Icon(Icons.language),
            title: Text("Language"),
            subtitle: Text("English"),
          ),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            subtitle: Text("MediAlert AI v1.0"),
          ),
        ],
      ),
    );
  }
}
