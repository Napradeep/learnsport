// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Hindi', 'Spanish'];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.bluePrimaryDual,
          primary: AppColors.bluePrimaryDual,
          secondary: AppColors.iconLightColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bluePrimaryDual,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'General',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: AppColors.iconColor,
              //   ),
              // ),
              // const SizedBox(height: 16),
              // Card(
              //   elevation: 4,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Column(
              //     children: [
              //       SwitchListTile(
              //         title: const Text('Notifications'),
              //         subtitle: const Text('Receive booking updates'),
              //         value: _notifications,
              //         onChanged: (value) =>
              //             setState(() => _notifications = value),
              //         activeColor: AppColors.bluePrimaryDual,
              //       ),
              //       const Divider(height: 1),
              //       SwitchListTile(
              //         title: const Text('Dark Mode'),
              //         subtitle: const Text('Enable dark theme'),
              //         value: _darkMode,
              //         onChanged: (value) => setState(() => _darkMode = value),
              //         activeColor: AppColors.bluePrimaryDual,
              //       ),
              //       const Divider(height: 1),
              //       ListTile(
              //         title: const Text('Language'),
              //         trailing: DropdownButton<String>(
              //           value: _selectedLanguage,
              //           items: _languages
              //               .map(
              //                 (lang) => DropdownMenuItem(
              //                   value: lang,
              //                   child: Text(lang),
              //                 ),
              //               )
              //               .toList(),
              //           onChanged: (value) =>
              //               setState(() => _selectedLanguage = value!),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 14),
              Text(
                'Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.iconColor,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock, color: Colors.orange),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Redirect to password change'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Logout'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logging out...')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.iconColor,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.info,
                    color: AppColors.bluePrimaryDual,
                  ),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
