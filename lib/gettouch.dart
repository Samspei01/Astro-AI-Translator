import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'them.dart';

class GetInTouchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astro AI Translator'),
      ),
      body: Container(
        color: Provider.of<ThemeNotifier>(context).isDarkMode ? Colors.black45 : Color(0xFFE5E0E0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ContactTile(
              name: 'Mohamed Refaat',
              email: 'morefaat356@gmail.com',
              emailUrl: 'morefaat356@gmail.com',
              linkedInUrl: 'https://www.linkedin.com/in/mohamed-refaat-a069b8307?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app',
              githubUrl: 'https://github.com/Mo-Refaat',
            ),
            SizedBox(height: 20),
            ContactTile(
              name: 'Abdelrhman Saaed',
              email: 'abdosaaed749@gmail.com',
              emailUrl: 'abdosaaed749@gmail.com',
              linkedInUrl: 'https://www.linkedin.com/in/abdelrhman-saeed-9b17b9238/',
              githubUrl: 'https://github.com/Samspei01',
            ),
          ],
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final String name;
  final String email;
  final String emailUrl;
  final String linkedInUrl;
  final String githubUrl;

  ContactTile({required this.name, required this.email, required this.emailUrl, required this.linkedInUrl, required this.githubUrl});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.email, color: isDarkMode ? Colors.white : Colors.black),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(

                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchURL(emailUrl),
                child: Text(
                  email,
                  style: TextStyle(
                    color: isDarkMode ? Colors.blue : Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchURL(linkedInUrl),
                child: Text(
                  'LinkedIn',
                  style: TextStyle(
                    color: isDarkMode ? Colors.blue : Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchURL(githubUrl),
                child: Text(
                  'GitHub',
                  style: TextStyle(
                    color: isDarkMode ? Colors.blue : Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
