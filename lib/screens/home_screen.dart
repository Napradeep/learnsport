import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sportspark/screens/admin_screen.dart';
import 'package:sportspark/screens/details_screen.dart';
import 'package:sportspark/screens/login/view/login_screen.dart';
import 'package:sportspark/screens/slot_booking_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/shared/shared_pref.dart';
import 'package:sportspark/utils/widget/drawer_menu.dart';
import 'package:sportspark/screens/sportslist/sports_provider.dart';

import 'package:shimmer/shimmer.dart';
import 'package:sportspark/utils/widget/sports_cache_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _listAnimationController;
  late final AnimationController _fadeController;
  late final ScrollController _scrollController;

  String? _role;

  // Global aggressive cache manager (7-day cache)
  final CacheManager cache = SportsCacheManager.instance;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();

    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scrollController = ScrollController();

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _listAnimationController.forward();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SportsProvider>().loadSports();
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final fetchedRole = await UserPreferences.getRole();
    if (!mounted) return;
    setState(() => _role = fetchedRole ?? "Unknown");
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _listAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ------------------- SHIMMERS -------------------

  Widget _bannerShimmer() {
    return SizedBox(
      height: 220,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.white),
      ),
    );
  }

  Widget _turfCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        height: 135,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // ------------------- CAROUSEL -------------------

  Widget _buildCarousel(List<Map<String, dynamic>> sports) {
    if (sports.isEmpty) return _bannerShimmer();

    return CarouselSlider.builder(
      itemCount: sports.length,
      itemBuilder: (context, index, realIdx) {
        final sport = sports[index];
        final bannerUrl =
            (sport['banner'] ?? sport['web_banner'] ?? "") as String;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsScreen(sportData: sport),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                cacheManager: cache,
                imageUrl: bannerUrl,
                fit: BoxFit.cover,
                memCacheHeight: 600,
                placeholder: (_, __) => Container(color: Colors.grey[300]),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.sports,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 12,
                child: Text(
                  sport['name'] ?? "Sport",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enableInfiniteScroll: true,
      ),
    );
  }

  // ------------------- TURF CARD -------------------

  Widget _buildTurfItem(
    BuildContext context,
    Map<String, dynamic> turf,
    int index,
  ) {
    final String imageUrl = (turf['image'] ?? "") as String;
    final String turfName = (turf['name'] ?? "Turf").toString();
    final String actualPrice = (turf['actual_price_per_slot'] ?? "0")
        .toString();
    final String finalPrice = (turf['final_price_per_slot'] ?? "0").toString();
    final bool isUnavailable =
        (turf['status'] ?? "").toString().toUpperCase() == "NOT_AVAILABLE";

    final double start = (index * 0.06).clamp(0.0, 0.7);
    final double end = (start + 0.45).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: _listAnimationController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      cacheManager: cache,
                      imageUrl: imageUrl,
                      memCacheHeight: 350,
                      height: 135,
                      width: 130,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 135,
                        width: 130,
                        color: Colors.grey[300],
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 135,
                        width: 130,
                        color: Colors.grey[300],
                        child: const Icon(Icons.sports_soccer, size: 42),
                      ),
                    ),
                    Container(
                      height: 135,
                      width: 130,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black26],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --------------- DETAILS ---------------
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        turfName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            "₹$actualPrice",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.redAccent,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "₹$finalPrice",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Book your slot now!",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

              // --------------- BOOK BTN ---------------
              Padding(
                padding: EdgeInsets.only(
                  right: 10,
                  top: MediaQuery.of(context).size.height * 0.08,
                ),
                child: ElevatedButton(
                  onPressed: isUnavailable
                      ? _showUnavailableDialog
                      : () {
                          MyRouter.push(
                            screen: SlotBookingScreen(
                              turfName: turfName,
                              sportsId: turf['_id'],
                              slotAmount: finalPrice,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUnavailable
                        ? Colors.grey
                        : AppColors.bluePrimaryDual,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- ALERT -------------------

  void _showUnavailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Note!"),
        content: const Text(
          "This sport is currently under maintenance. Please try again later!.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ------------------- BUILD -------------------

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<SportsProvider, bool>((p) => p.isLoading);
    final sportsList = context
        .select<SportsProvider, List<Map<String, dynamic>>>(
          (p) => List<Map<String, dynamic>>.from(p.sports),
        );

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.bluePrimaryDual,
          primary: AppColors.bluePrimaryDual,
          secondary: AppColors.iconLightColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bluePrimaryDual,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black26,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text(
            "LearnFort Sports Park",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (_role == "USER" ||
                    _role == "ADMIN" ||
                    _role == "SUPER_ADMIN") {
                  MyRouter.push(screen: AdminScreen(heading: _role));
                } else {
                  MyRouter.push(screen: const LoginScreen());
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: AppColors.bluePrimaryDual,
                ),
              ),
            ),
          ],
        ),

        drawer: DrawerMenu(isAdmin: _role ?? ""),

        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeController,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(3),
                  height: 220,
                  child: _buildCarousel(sportsList),
                ),
              ),
            ),

            // Title
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: const [
                    Icon(
                      Icons.sports_soccer,
                      color: AppColors.bluePrimaryDual,
                      size: 26,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Available Turfs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: isLoading
                  ? SliverList.builder(
                      itemBuilder: (_, __) => _turfCardShimmer(),
                      itemCount: 4,
                    )
                  : SliverList.builder(
                      itemBuilder: (_, i) =>
                          _buildTurfItem(context, sportsList[i], i),
                      itemCount: sportsList.length,
                    ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
