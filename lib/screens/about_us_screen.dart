import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  final double latitude = 10.168391;
  final double longitude = 77.8158151;

  Future<void> _openGoogleMaps() async {
    final String mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      if (await canLaunchUrlString(mapsUrl)) {
        await launchUrlString(mapsUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch Maps URL');
      }
    } catch (e) {
      debugPrint('Error launching maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(latitude, longitude);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
            // HEADER
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.iconLightColor, AppColors.bluePrimaryDual],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

            // ABOUT SECTION
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

            // SPORTS SECTION
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

            // AMENITIES SECTION
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

            // MAP SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "📍 Location:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.iconColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GestureDetector(
                      onTap: _openGoogleMaps,
                      child: SizedBox(
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: location,
                            initialZoom: 16,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.none,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.sportspark',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: location,
                                  width: 40,
                                  height: 40,
                                  child: IconButton(
                                    onPressed: _openGoogleMaps,
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.redAccent,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _openGoogleMaps,
                    child: const Text(
                      "Tap the map to navigate in Google Maps",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CONTACT SECTION
            Container(
              width: double.infinity,
              color: AppColors.iconColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    "LearnFort Sports Park\n"
                    "Bangalapatti, Dindigul, Tamil Nadu 624202\n"
                    "Phone: +91 98765 43210\n"
                    "Email: info@learnfortsports.com",
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

// SPORT CHIP
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

// FACILITY TEXT
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
