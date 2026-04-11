import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In real app, watch ThemeProvider
    const isDarkMode = false;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("App Settings",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 32),
            const Text("Appearance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: isDarkMode,
              onChanged: (val) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Theme toggle not implemented in MVP yet")));
              },
            ),
            const Divider(height: 48),
            const Text("Data Management",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text("Export Data"),
              subtitle: const Text("Download all project data as JSON"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Export started...")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Clear All Data",
                  style: TextStyle(color: Colors.red)),
              subtitle: const Text("Permanently remove all local data"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Clear Data?"),
                          content: const Text("This action cannot be undone."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // ref.read(databaseProvider).close();
                                // In real app, execute delete queries
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Data cleared (Mock)")));
                              },
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            )
                          ],
                        ));
              },
            ),
            const Divider(height: 48),
            const Text("About",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const ListTile(
              title: Text("Version"),
              subtitle: Text("1.0.0 (MVP)"),
            ),
          ],
        ),
      ),
    );
  }
}
