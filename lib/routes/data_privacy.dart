import 'package:curve/services/colors_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataPrivacy extends StatelessWidget {
  const DataPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data & Privacy")),
      body: Consumer<ColorsProvider>(builder: (context, color, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(context, "1. Information We Collect", color),
              _sectionText(
                  "We collect information you provide directly to us, such as your email address when you create an account. We also collect data related to your game progress (scores, room IDs) to facilitate multiplayer features.",
                  color),
              _divider(color),
              _sectionTitle(context, "2. How We Use Your Data", color),
              _sectionText(
                  "• To provide and maintain the App.\n• To facilitate real-time multiplayer games.\n• To save your preferences locally on your device.",
                  color),
              _divider(color),
              _sectionTitle(context, "3. Data Storage & Security", color),
              _sectionText(
                  "Your data is stored securely using Google Firebase services. We implement standard security measures to protect your information. Local preferences (like Dark Mode and Kinks settings) are stored strictly on your device.",
                  color),
              _divider(color),
              _sectionTitle(context, "4. Your Rights", color),
              _sectionText(
                  "You can request to delete your account at any time via the Settings menu. This will permanently remove your authentication record and personal data from our servers.",
                  color),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.placeHolders(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.privacy_tip_outlined, size: 30),
                    const SizedBox(height: 10),
                    const Text(
                      "Full Privacy Policy",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "https://www.evesdrops.in/privacy",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(
      BuildContext context, String title, ColorsProvider color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: color.navBarIconActiveColor(),
            ),
      ),
    );
  }

  Widget _sectionText(String text, ColorsProvider color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        height: 1.6,
        color: color.navBarIconActiveColor().withOpacity(0.8),
      ),
    );
  }

  Widget _divider(ColorsProvider color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Divider(color: color.navBarIconActiveColor().withOpacity(0.1)),
    );
  }
}
