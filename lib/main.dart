import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'them.dart';
import 'translator.dart';
import 'camera.dart';
import 'more.dart';
import 'gettouch.dart';
import 'Privacy_Policy.dart';
import 'temsprivecy.dart';
import 'logo.dart';
import 'Subscription.dart';
import 'welcome page.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: AstroAITranslatorApp(),
    ),
  );
}

class AstroAITranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Astro AI Translator',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/terms': (context) => TermsPage(),
            '/privacy': (context) => PrivacyPolicyPage(),
            '/text': (context) => TranslatorPage(),
            '/camera': (context) => CameraPage(),
            '/more': (context) => SettingsPage(),
            '/get_in_touch': (context) => GetInTouchPage(),
            '/sub': (context) => SubscriptionScreen(),
            '/welcome': (context) => WelcomePage(),
          },
        );
      },
    );
  }
}
