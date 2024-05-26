import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'them.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: isDarkMode ? Colors.transparent : Colors.white10 ,
      ),
      body: Container(
        color: isDarkMode ? Colors.black45 : Color(0xFFE5E0E0),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Theme Mode'),
              trailing: Consumer<ThemeNotifier>(
                builder: (context, themeNotifier, child) {
                  return DropdownButton<String>(
                    value: themeNotifier.isDarkMode ? 'Dark' : 'Light',
                    items: ['System', 'Dark', 'Light'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        themeNotifier.setThemeMode(newValue);
                      }
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('Select text size'),
              trailing: Consumer<ThemeNotifier>(
                builder: (context, themeNotifier, child) {
                  return DropdownButton<int>(
                    value: themeNotifier.textSize,
                    items: [14, 16, 18, 20].map((size) {
                      return DropdownMenuItem<int>(
                        value: size,
                        child: Text('$size'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        themeNotifier.setTextSize(value);
                      }
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.record_voice_over),
              title: Text("Select the speaker's voice"),
              trailing: Consumer<ThemeNotifier>(
                builder: (context, themeNotifier, child) {
                  return DropdownButton<String>(
                    value: themeNotifier.selectedVoice,
                    items: ['Default', 'Male', 'Female'].map((voice) {
                      return DropdownMenuItem<String>(
                        value: voice,
                        child: Text(voice),
                      );
                    }).toList(),
                    onChanged: (value) {
                      themeNotifier.setVoice(value!);
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Get in touch'),
              onTap: () {
                Navigator.pushNamed(context, '/get_in_touch');
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Terms of service'),
              onTap: () {
                Navigator.pushNamed(context, '/terms');
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy policy'),
              onTap: () {
                Navigator.pushNamed(context, '/privacy');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Manage your purchases'),
              onTap: () {
                Navigator.pushNamed(context, '/sub');
              },
            ),
          ],
        ),
      ),
    );
  }
}
