import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'We provide a broad range of services that are subject to these terms, including:\n'
                      '• apps and sites (like Search and Maps)\n'
                      '• platforms (like Astro Shopping)\n'
                      '• integrated services (like Maps embedded in other companies\' apps or sites)\n'
                      '• devices (like Astro Nest)\n'
                      'Many of these services also include content that you can stream or interact with.\n\n'
                      'Our services are designed to work together, making it easier for you to move from one activity to the next. For example, if your Calendar event includes an address, you can click on that address and Maps can show you how to get there.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
