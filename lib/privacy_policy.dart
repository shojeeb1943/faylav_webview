import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: const Color(0xFFFF3399),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Faylav WebView App Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: March 28, 2024',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Overview'),
            _buildSectionContent(
              'The Faylav WebView app is a simple application that provides a convenient way to access the Faylav website. This privacy policy explains how we handle your information when you use our app.',
            ),
            _buildSectionTitle('Information Collection'),
            _buildSectionContent(
              'The Faylav WebView app itself does not collect or store any personal information. The app functions as a browser that connects to the Faylav website. Any information you provide while using the Faylav website is subject to the Faylav website\'s own privacy policy.',
            ),
            _buildSectionTitle('Permissions'),
            _buildSectionContent(
              'The app requires only the INTERNET permission to function. This permission is necessary to load the Faylav website content.',
            ),
            _buildSectionTitle('Cookies and Local Storage'),
            _buildSectionContent(
              'To provide a seamless experience, the app preserves cookies and local storage data from the Faylav website. This allows you to stay logged in and maintain your session. This data is stored locally on your device and is not accessed by us.',
            ),
            _buildSectionTitle('Third-Party Links'),
            _buildSectionContent(
              'The app may open links to external websites in your device\'s browser. We are not responsible for the privacy practices of these external websites.',
            ),
            _buildSectionTitle('Children\'s Privacy'),
            _buildSectionContent(
              'Our app does not specifically target children under the age of 13. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSectionTitle('Changes to This Policy'),
            _buildSectionContent(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
            ),
            _buildSectionTitle('Contact Us'),
            _buildSectionContent(
              'If you have any questions about this Privacy Policy, please contact us at support@faylav.com.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
