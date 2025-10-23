import 'package:flutter/material.dart';
import 'package:sportspark/utils/widget/custom_button.dart';
import 'package:sportspark/utils/const/const.dart';

class DetailsScreen extends StatefulWidget {
  final String gameName;
  final String imagePath;

  const DetailsScreen({
    super.key,
    required this.gameName,
    required this.imagePath,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Constants for reusable values
  static const _heroImageHeight = 280.0;
  static const _animationDuration = Duration(milliseconds: 800);
  static const _borderRadius = 30.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Game details mapping
    final Map<String, String> gameDetails = {
      'Football (Turf) 14,000 sqft':
          'Play on our 14,000 sq.ft. turf with night lighting, professional-grade flooring, and equipment. Perfect for casual games or tournaments!',
      'Cricket (Turf)':
          'Enjoy net practice or team matches on high-quality turf pitches. Bowling machine and lights available for night sessions.',
      'Basketball':
          'Experience full-sized basketball courts with cushioned flooring and high-grade hoops, ideal for practice and friendly matches.',
      'Volleyball':
          'Top-notch volleyball courts with soft sand surface, perfect for competitive and recreational matches.',
      'Skating':
          'Smooth tracks for beginners and professionals with safety barriers and coaching available.',
      'Badminton (Outdoor)':
          'Indoor and outdoor badminton courts coming soon with advanced flooring and LED lighting.',
      'Pickle Ball':
          'Enjoy pickleball on our specialized courts with premium surfaces and equipment.',
      'Kabaddi':
          'Play kabaddi on our professional-grade mats with excellent grip and safety features.',
      'Karate':
          'Practice karate in our dedicated dojo with cushioned flooring and expert instructors.',
      'Athletic Track':
          'Run on our world-class athletic track designed for speed and endurance training.',
      'Archery':
          'Test your precision on our archery range with professional targets and equipment.',
      'Cricket (Net Practice)':
          'Hone your skills in our net practice area with high-quality nets and bowling machines.',
    };

    final detailText =
        gameDetails[widget.gameName] ??
        'LearnFort Sports Park offers world-class facilities and equipment for all players — from beginners to professionals.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.gameName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image Header
                Stack(
                  children: [
                    Hero(
                      tag: widget.imagePath,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(_borderRadius),
                          bottomRight: Radius.circular(_borderRadius),
                        ),
                        child: Image.asset(
                          widget.imagePath,
                          height: _heroImageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: _heroImageHeight,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                    Container(
                      height: _heroImageHeight,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(_borderRadius),
                          bottomRight: Radius.circular(_borderRadius),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 25,
                      child: Text(
                        widget.gameName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ScaleTransition(
                    scale: Tween(begin: 0.9, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: CustomButton(
                      text: 'Book a Slot Now',
                      color: Colors.white,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/slot_booking',
                        arguments: widget.gameName,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // About Section Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.bluePrimaryDual.withOpacity(0.1),
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About ${widget.gameName}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.iconColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              detailText,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Facilities
                      const Text(
                        'Facilities Available:',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          _AnimatedFacilityChip(
                            icon: Icons.light_mode,
                            label: 'Night Lighting',
                          ),
                          _AnimatedFacilityChip(
                            icon: Icons.shower_outlined,
                            label: 'Rest Rooms',
                          ),
                          _AnimatedFacilityChip(
                            icon: Icons.local_dining,
                            label: 'Food Court',
                          ),
                          _AnimatedFacilityChip(
                            icon: Icons.fitness_center,
                            label: 'Open Gym',
                          ),
                          _AnimatedFacilityChip(
                            icon: Icons.wifi,
                            label: 'Wi-Fi',
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Book Slot Button
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedFacilityChip extends StatefulWidget {
  final IconData icon;
  final String label;

  const _AnimatedFacilityChip({required this.icon, required this.label});

  @override
  State<_AnimatedFacilityChip> createState() => _AnimatedFacilityChipState();
}

class _AnimatedFacilityChipState extends State<_AnimatedFacilityChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Chip(
          backgroundColor: AppColors.iconColor.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: AppColors.iconColor),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
