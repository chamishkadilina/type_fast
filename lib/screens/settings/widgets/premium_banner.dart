// lib/screens/settings/widgets/premium_banner.dart
import 'package:flutter/material.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unlock Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enjoy exclusive features:',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          ...['Ad Removal', 'Advanced Statistics', 'Daily Notifications']
              .map((benefit) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          benefit,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implement premium upgrade logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
            ),
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }
}
