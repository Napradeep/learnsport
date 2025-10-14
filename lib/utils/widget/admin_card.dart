import 'package:flutter/material.dart';

class AdminCardData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Function()? onTap;

  const AdminCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    this.onTap,
  });
}

// 🔹 Card Widget
class AdminDashboardCard extends StatelessWidget {
  final AdminCardData data;
  final Function()? onTap;

  const AdminDashboardCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? data.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: data.title,
              child: CircleAvatar(
                backgroundColor: data.color.withOpacity(0.15),
                radius: 30,
                child: Icon(data.icon, color: data.color, size: 32),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: data.color.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}
