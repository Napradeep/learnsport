import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class SportsGame extends StatefulWidget {
  const SportsGame({super.key});

  @override
  State<SportsGame> createState() => _SportsGameState();
}

class _SportsGameState extends State<SportsGame>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> sportsData = [
    {'name': 'Skating', 'icon': Icons.ice_skating},
    {'name': 'Pickle Ball', 'icon': Icons.sports_tennis},
    {'name': 'Basketball', 'icon': Icons.sports_basketball},
    {'name': 'Kabaddi', 'icon': Icons.sports_kabaddi},
    {'name': 'Football (Turf) 14,000 sqft', 'icon': Icons.sports_soccer},
    {'name': 'Karate', 'icon': Icons.sports_martial_arts},
    {'name': 'Volleyball', 'icon': Icons.sports_volleyball},
    {'name': 'Athletic Track', 'icon': Icons.directions_run},
    {'name': 'Cricket (Turf)', 'icon': Icons.sports_cricket},
    {'name': 'Archery', 'icon': Icons.track_changes},
    {'name': 'Cricket (Net Practice)', 'icon': Icons.sports_cricket},
    {'name': 'Badminton (Outdoor)', 'icon': Icons.sports_tennis},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Sports',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: sportsData.length,
          itemBuilder: (context, index) {
            final data = sportsData[index];

            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + index * 120),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                final opacity = value.clamp(
                  0.0,
                  1.0,
                ); // 🧠 Prevents out-of-range values
                return Transform.scale(
                  scale: value,
                  child: Opacity(opacity: opacity, child: child),
                );
              },
              child: _AnimatedCard(
                name: data['name'],
                icon: data['icon'],
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const _AnimatedCard({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.bluePrimaryDual.withOpacity(0.9),
                AppColors.bluePrimaryDual.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.bluePrimaryDual.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  widget.icon,
                  size: 36,
                  color: AppColors.bluePrimaryDual,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
