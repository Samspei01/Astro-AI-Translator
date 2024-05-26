import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "This Privacy Policy outlines how information collected through the Astro AI Translator app is used and safeguarded. By using our app, you consent to the collection and use of your data in accordance with this policy.\n\n"
                  "Information Collection:\n"
                  "- We collect information you provide directly to us, such as when you create an account, submit queries, or communicate with us.\n"
                  "- We automatically collect certain information when you use the app, including usage details, IP addresses, and information collected through cookies and other tracking technologies.\n\n"
                  "Use of Information:\n"
                  "- To provide and maintain our service\n"
                  "- To notify you about changes to our service\n"
                  "- To allow you to participate in interactive features when you choose to do so\n"
                  "- To provide customer support\n"
                  "- To gather analysis or valuable information so that we can improve our service\n"
                  "- To monitor the usage of our service\n"
                  "- To detect, prevent and address technical issues\n\n"
                  "Disclosure of Data:\n"
                  "- We may disclose your personal information where required to do so by law or subpoena.\n"
                  "- We may disclose your information to protect the rights, property, or safety of our users, the public, or ourselves.\n\n"
                  "Security:\n"
                  "The security of your data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.\n\n"
                  "Changes to This Privacy Policy:\n"
                  "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n"
                  "Contact Us:\n"
                  "If you have any questions about this Privacy Policy, please contact us.",
              style: TextStyle(fontSize: 16, height: 1.5),

            ),
            SizedBox(height: 20),
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
