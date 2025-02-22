import 'package:flutter/material.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Welcome to Mihfadati",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Everything you need in one app",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildServiceCard(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(int index) {
    final cards = [
      {
        'icon': Icons.credit_card,
        'title': "Smart City Card",
        'subtitle': "Your Digital City Services Card",
        'details': {"Balance": "40000 DA"},
        'color': Colors.blue,
      },
      {
        'icon': Icons.description,
        'title': "E-Documents",
        'subtitle': "Manage and share your documents securely",
        'details': {"Documents": "4", "Pending Transfer": "2"},
        'color': Colors.green,
      },
      {
        'icon': Icons.route,
        'title': "Smart Route",
        'subtitle': "Find the best route possible",
        'details': {"Traffic": "Normal", "Weather": "Sunny"},
        'color': Colors.orange,
      },
    ];

    final card = cards[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: card['color'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                card['icon'] as IconData,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card['subtitle'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    children: (card['details'] as Map<String, String>)
                        .entries
                        .map((entry) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${entry.key}: ",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: card['color'] as Color,
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
