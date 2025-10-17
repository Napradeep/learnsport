import 'package:flutter/material.dart';

class AdminCardData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const AdminCardData({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

class AdminDashboardCard extends StatefulWidget {
  final AdminCardData data;

  const AdminDashboardCard({super.key, required this.data});

  @override
  State<AdminDashboardCard> createState() => _AdminDashboardCardState();
}

class _AdminDashboardCardState extends State<AdminDashboardCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: data.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.03))
              : Matrix4.identity(),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: data.color.withOpacity(0.2), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                blurRadius: _isHovered ? 10 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: data.color.withOpacity(0.15),
                child: Icon(data.icon, color: data.color, size: 32),
              ),
              const SizedBox(height: 10),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: data.color.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
