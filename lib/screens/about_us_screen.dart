// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:sportspark/utils/const/const.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class AboutUsScreen extends StatelessWidget {
//   const AboutUsScreen({super.key});

//   final double latitude = 10.168391;
//   final double longitude = 77.8158151;

//   Future<void> _openGoogleMaps() async {
//     final String mapsUrl =
//         'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

//     try {
//       if (await canLaunchUrlString(mapsUrl)) {
//         await launchUrlString(mapsUrl, mode: LaunchMode.externalApplication);
//       } else {
//         debugPrint('Could not launch Maps URL');
//       }
//     } catch (e) {
//       debugPrint('Error launching maps: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final LatLng location = LatLng(latitude, longitude);

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'About Us',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: false,
//         backgroundColor: AppColors.bluePrimaryDual,
//         elevation: 4,
//         shadowColor: Colors.black26,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // HEADER
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppColors.iconLightColor, AppColors.bluePrimaryDual],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "LearnFort Sports Park",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "An all-in-one sports arena located in Dindigul.",
//                     style: TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ABOUT SECTION
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 "At LearnFort Sports Park, we believe in nurturing fitness, teamwork, and passion for sports. "
//                 "Spread across a massive 14,000 sqft, our multi-sport facility offers top-notch turfs and courts "
//                 "for both beginners and professionals. We aim to provide a safe, engaging, and energetic environment "
//                 "for all age groups to train, play, and excel.",
//                 style: TextStyle(
//                   fontSize: 16,
//                   height: 1.5,
//                   color: Colors.grey[800],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // SPORTS SECTION
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 "🏆 Available Sports & Facilities:",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.iconColor,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: const [
//                   _SportChip("Skating"),
//                   _SportChip("Basketball"),
//                   _SportChip("Football (Turf)"),
//                   _SportChip("Volleyball"),
//                   _SportChip("Cricket (Turf)"),
//                   _SportChip("Net Practice"),
//                   _SportChip("Pickleball"),
//                   _SportChip("Kabbadi"),
//                   _SportChip("Karate"),
//                   _SportChip("Athletic Track"),
//                   _SportChip("Archery"),
//                   _SportChip("Badminton (Outdoor)"),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // AMENITIES SECTION
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 "🎯 Amenities:",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.iconColor,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   _FacilityText("Lighting for Night Events"),
//                   _FacilityText("Bowling Machine for Practice"),
//                   _FacilityText("Open Gym"),
//                   _FacilityText("Children Play Area"),
//                   _FacilityText("Rest Rooms"),
//                   _FacilityText("Food Court"),
//                   _FacilityText("Walking Pathway"),
//                   _FacilityText("EV Charging Station"),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // MAP SECTION
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "📍 Location:",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: AppColors.iconColor,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: GestureDetector(
//                       onTap: _openGoogleMaps,
//                       child: SizedBox(
//                         height: 200,
//                         child: FlutterMap(
//                           options: MapOptions(
//                             initialCenter: location,
//                             initialZoom: 16,
//                             interactionOptions: const InteractionOptions(
//                               flags: InteractiveFlag.none,
//                             ),
//                           ),
//                           children: [
//                             TileLayer(
//                               urlTemplate:
//                                   'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                               userAgentPackageName: 'com.example.sportspark',
//                             ),
//                             MarkerLayer(
//                               markers: [
//                                 Marker(
//                                   point: location,
//                                   width: 40,
//                                   height: 40,
//                                   child: IconButton(
//                                     onPressed: _openGoogleMaps,
//                                     icon: Icon(
//                                       Icons.location_on,
//                                       color: Colors.redAccent,
//                                       size: 40,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: _openGoogleMaps,
//                     child: const Text(
//                       "Tap the map to navigate in Google Maps",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // CONTACT SECTION
//             Container(
//               width: double.infinity,
//               color: AppColors.iconColor.withOpacity(0.1),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 25.0,
//               ),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "📞 Contact Us",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: AppColors.iconColor,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "LearnFort Sports Park\n"
//                     "Bangalapatti, Dindigul, Tamil Nadu 624202\n"
//                     "Phone: +91 98765 43210\n"
//                     "Email: info@learnfortsports.com",
//                     style: TextStyle(fontSize: 16, height: 1.5),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // SPORT CHIP
// class _SportChip extends StatelessWidget {
//   final String label;
//   const _SportChip(this.label);

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       label: Text(label),
//       backgroundColor: AppColors.bluePrimaryDual.withOpacity(0.1),
//       labelStyle: const TextStyle(color: AppColors.iconColor),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     );
//   }
// }

// // FACILITY TEXT
// class _FacilityText extends StatelessWidget {
//   final String text;
//   const _FacilityText(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text("• $text", style: const TextStyle(fontSize: 16)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ================== HELPERS ==================

Future<void> _openGoogleMaps() async {
  const String mapsUrl = "https://maps.app.goo.gl/mZegNnLFtdQ87mFf9?g_st=aw";
  await launchUrlString(mapsUrl, mode: LaunchMode.externalApplication);
}

Future<void> _launchPhone(String phone) async {
  await launchUrlString("tel:$phone");
}

Future<void> _launchWhatsApp(String phoneWithCountryCode) async {
  await launchUrlString("https://wa.me/$phoneWithCountryCode");
}

Future<void> _launchEmail(String email) async {
  await launchUrlString("mailto:$email");
}

Future<void> _launchExternalUrl(String url) async {
  await launchUrlString(url, mode: LaunchMode.externalApplication);
}

// ================== SCREEN ==================

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  final double latitude = 10.168391;
  final double longitude = 77.8158151;

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(latitude, longitude);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "About Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.bluePrimaryDual,
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
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
                    "A Premier Hub for Sports, Skill & Excellence.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ABOUT CONTENT UPDATED
            _sectionText(
              "LearnFort Sports Park stands as a premier institution in the realm of sports management, dedicated to transforming the global sports ecosystem."
              "\n\nLearnFort Sports Park is a pioneering initiative committed to igniting a nationwide passion for sports and revolutionizing athletic participation across India."
              "\n\nWe serve as a unified hub where world-class coaching, sports education, and exhilarating tournaments converge. Our mission is to empower individuals toward fitness, discipline, and self-discovery by providing a vibrant ecosystem of support, guidance, and opportunity."
              "\n\nOur holistic approach blends professional facilities, advanced training techniques, and technological innovation—preparing athletes for success on and off the field.",
            ),

            const SizedBox(height: 20),

            /// SPORTS SECTION
            const _SectionTitle("🏆 Available Sports & Facilities"),
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

            /// AMENITIES SECTION
            const _SectionTitle("🎯 Amenities"),
            const SizedBox(height: 10),

            _facilityList([
              "Lighting for Night Events",
              "Bowling Machine for Practice",
              "Open Gym",
              "Children Play Area",
              "Rest Rooms",
              "Food Court",
              "Walking Pathway",
              "EV Charging Station",
            ]),

            const SizedBox(height: 30),

            /// MAP SECTION
            const _SectionTitle("📍 Location"),
            const SizedBox(height: 10),
            _mapSection(location),

            const SizedBox(height: 30),

            /// CONTACT SECTION
            const _ContactSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ================== COMMON SECTIONS ==================

Widget _sectionText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[800]),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.iconColor,
        ),
      ),
    );
  }
}

Widget _facilityList(List<String> facilities) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: facilities.map((text) => _FacilityText(text)).toList(),
    ),
  );
}

Widget _mapSection(LatLng location) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                          size: 40,
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
        const Text(
          "Tap the map to navigate in Google Maps",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

// ================== CONTACT SECTION (PRO UI) ==================

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.iconColor.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📞 Contact Us",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.iconColor,
            ),
          ),
          const SizedBox(height: 16),

          // Address Card
          InkWell(
            onTap: _openGoogleMaps,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.location_on, color: AppColors.iconColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "LearnFort Sports Park,\n"
                      "Batlagundu Road, Bangalapatti,\n"
                      "Nilakottai, Dindigul - 624202,\n"
                      "Tamil Nadu, India.",
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                  Icon(Icons.directions_outlined, color: Colors.grey),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Action Tiles Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _ActionTile(
                  icon: Icons.call,
                  title: "Call (Landline)",
                  subtitle: "+91 45432 45622",
                  onTap: () => _launchPhone("+914543245622"),
                ),
                const Divider(height: 0),
                _ActionTile(
                  icon: Icons.phone_iphone,
                  title: "Call (Mobile)",
                  subtitle: "+91 81247 45622",
                  onTap: () => _launchPhone("+918124745622"),
                ),
                const Divider(height: 0),
                _ActionTile(
                  icon: Icons.messenger_outlined,
                  title: "WhatsApp",
                  subtitle: "+91 94441 23722",
                  onTap: () => _launchWhatsApp("919444123722"),
                ),
                const Divider(height: 0),
                _ActionTile(
                  icon: Icons.email_outlined,
                  title: "Email",
                  subtitle:
                      "info@learnfortsports.com\nlearnfortsports@gmail.com",
                  onTap: () => _launchEmail("info@learnfortsports.com"),
                ),
                const Divider(height: 0),
                _ActionTile(
                  icon: Icons.language,
                  title: "Website",
                  subtitle: "www.learnfortsports.com",
                  onTap: () =>
                      _launchExternalUrl("https://www.learnfortsports.com"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "🔗 Follow us",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.iconColor,
            ),
          ),
          const SizedBox(height: 10),

          // Social Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SocialIconButton(
                icon: Icons.camera_alt_outlined,
                label: "Instagram",
                onTap: () =>
                    _launchExternalUrl("https://instagram.com/learnfortsports"),
              ),
              _SocialIconButton(
                icon: Icons.business_center_outlined,
                label: "LinkedIn",
                onTap: () => _launchExternalUrl(
                  "https://www.linkedin.com/company/learnfortsports",
                ),
              ),
              _SocialIconButton(
                icon: Icons.play_circle_fill,
                label: "YouTube",
                onTap: () => _launchExternalUrl(
                  "https://www.youtube.com/@learnfortsports",
                ),
              ),
              _SocialIconButton(
                icon: Icons.facebook,
                label: "Facebook",
                onTap: () => _launchExternalUrl(
                  "https://www.facebook.com/learnfortsports",
                ),
              ),
              _SocialIconButton(
                icon: Icons.alternate_email,
                label: "X",
                onTap: () =>
                    _launchExternalUrl("https://x.com/learnfortsports"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================== SMALL WIDGETS ==================

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.bluePrimaryDual.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(icon, size: 24, color: AppColors.iconColor),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
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
