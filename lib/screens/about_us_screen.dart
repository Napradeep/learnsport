import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),

        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.iconLightColor, AppColors.bluePrimaryDual],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "LearnFort Sports Park",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "An all-in-one sports arena located in Dindigul.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "At LearnFort Sports Park, we believe in nurturing fitness, teamwork, and passion for sports. "
                "Spread across a massive 14,000 sqft, our multi-sport facility offers top-notch turfs and courts "
                "for both beginners and professionals. We aim to provide a safe, engaging, and energetic environment "
                "for all age groups to train, play, and excel.",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[800],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "🏆 Available Sports & Facilities:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.iconColor,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _SportChip("Skating"),
                  _SportChip("Basketball"),
                  _SportChip("Football (Turf)"),
                  _SportChip("Volleyball"),
                  _SportChip("Cricket (Turf)"),
                  _SportChip("Net Practice"),
                  _SportChip("Pickleball"),
                  _SportChip("Kabbadi"),
                  _SportChip("Karate"),
                  _SportChip("Athletic Track"),
                  _SportChip("Archery"),
                  _SportChip("Badminton (Outdoor)"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "🎯 Amenities:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.iconColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _FacilityText("Lighting for Night Events"),
                  _FacilityText("Bowling Machine for Practice"),
                  _FacilityText("Open Gym"),
                  _FacilityText("Children Play Area"),
                  _FacilityText("Rest Rooms"),
                  _FacilityText("Food Court"),
                  _FacilityText("Walking Pathway"),
                  _FacilityText("EV Charging Station"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              color: AppColors.iconColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "📞 Contact Us",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.iconColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "LearnFort Sports Park\nDindigul, Tamil Nadu\nPhone: +91 98765 43210\nEmail: info@learnfortsports.com",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SportChip extends StatelessWidget {
  final String label;
  const _SportChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: AppColors.bluePrimaryDual.withOpacity(0.1),
      labelStyle: const TextStyle(color: AppColors.iconColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _FacilityText extends StatelessWidget {
  final String text;
  const _FacilityText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("• $text", style: const TextStyle(fontSize: 16)),
    );
  }
}
