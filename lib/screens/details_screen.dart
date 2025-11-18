import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportspark/screens/slot_booking_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/widget/custom_button.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> sportData;

  const DetailsScreen({super.key, required this.sportData});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  static const double _heroImageHeight = 280.0;
  static const double _borderRadius = 30.0;
  static const Duration _animationDuration = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scale = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _s(dynamic v) => v?.toString() ?? "";

  @override
  Widget build(BuildContext context) {
    final data = widget.sportData;

    final name = _s(data["name"]);
    final about = _s(data["about"]);
    final actualPrice = data["actual_price_per_slot"] ?? 0;
    final finalPrice = data["final_price_per_slot"] ?? 0;
    final groundName = _s(data["ground_name"]);
    final status = _s(data["status"]).toUpperCase();

    final nightHalf = data["sport_lighting_price_half"] ?? 100;
    final nightFull = data["sport_lighting_price_full"] ?? 200;

    final imageUrl = _s(data["banner"]).isEmpty
        ? _s(data["banner"])
        : _s(data["web_banner"]);

    final heroTag = data['_id'] != null
        ? "sport_${data['_id']}"
        : "sport_${name}_$imageUrl";

    final isAvailable =
        status == "AVAILABLE" || status == "OPEN" || status == "TRUE";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: AppColors.bluePrimaryDual,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- HERO IMAGE ----------------
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(_borderRadius),
                      bottomRight: Radius.circular(_borderRadius),
                    ),
                    child: SizedBox(
                      height: _heroImageHeight,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade300),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ---------------- BOOK BUTTON ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ScaleTransition(
                    scale: _scale,
                    child: CustomButton(
                      text: isAvailable
                          ? "Book a Slot Now"
                          : "Currently Unavailable",
                      color: isAvailable ? Colors.white : Colors.grey.shade300,
                      onPressed: isAvailable
                          ? () {
                              MyRouter.push(
                                screen: SlotBookingScreen(
                                  turfName: name,
                                  sportsId: data['_id']?.toString() ?? "",
                                  slotAmount: finalPrice.toString(),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ---------------- FIRST CONTAINER (OLD UI) ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.bluePrimaryDual.withOpacity(0.08),
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
                        // Title
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.iconColor,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Ground Name
                        if (groundName.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                groundName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),

                        if (actualPrice == finalPrice)
                          Row(
                            children: [
                              const Text(
                                "Price : ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "₹$finalPrice",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      "Actual Price : ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "₹$actualPrice",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Text(
                                      "Final Price : ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "₹$finalPrice",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 18),

                        // ================= NIGHT LIGHT PRICE SECTION =================
                        // ================= NIGHT LIGHT PRICE SECTION =================
if (nightHalf == nightFull)
  Row(
    children: [
      const Text(
        "Lighting price for night time : ",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      Text(
        "₹$nightHalf",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  )
else
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Lighting price for night time :",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Text(
                  "Half ground : ",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "₹$nightHalf",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Text(
                  "Full ground : ",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "₹$nightFull",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- SECOND CONTAINER (ABOUT ONLY) ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.bluePrimaryDual.withOpacity(0.08),
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
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(20),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.06),
                    //       blurRadius: 10,
                    //       offset: const Offset(0, 4),
                    //     ),
                    //   ],
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About $name",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.iconColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          about,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ---------------- FACILITY CHIPS ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    "Facilities Available:",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _AnimatedFacilityChip(
                        icon: Icons.light_mode,
                        label: "Night Lighting",
                      ),
                      _AnimatedFacilityChip(
                        icon: Icons.shower_outlined,
                        label: "Rest Rooms",
                      ),
                      _AnimatedFacilityChip(
                        icon: Icons.local_dining,
                        label: "Food Court",
                      ),
                      _AnimatedFacilityChip(
                        icon: Icons.fitness_center,
                        label: "Open Gym",
                      ),
                      _AnimatedFacilityChip(
                        icon: Icons.directions_walk_outlined,
                        label: "Walking Path",
                      ),
                      _AnimatedFacilityChip(
                        icon: Icons.child_care,
                        label: "Children’s Play Station",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.bluePrimaryDual,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.bluePrimaryDual,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- FACILITY CHIP ----------------
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
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(
      begin: 0.85,
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
          labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: AppColors.iconColor),
              const SizedBox(width: 8),
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
