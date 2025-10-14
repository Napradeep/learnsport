import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sportspark/screens/details_screen.dart';
import 'package:sportspark/utils/const/const.dart';
import 'package:sportspark/utils/widget/drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _banners = [
    {'image': 'assets/basketball.jpg', 'name': 'Basketball'},
    {'image': 'assets/crickettruf.jpg', 'name': 'Cricket Turf'},
    {'image': 'assets/kabadi.jpg', 'name': 'Kabaddi'},
    {'image': 'assets/karate.jpg', 'name': 'Karate'},
    {'image': 'assets/skating.jpg', 'name': 'Skating'},
    {'image': 'assets/volleyball.jpg', 'name': 'Volleyball'},
  ];

  final List<Map<String, dynamic>> _turfs = [
    {
      'name': 'Ocean Turf',
      'icon': Icons.waves,
      'color': Colors.blue,
      'image': 'assets/volleyball.jpg',
    },
    {
      'name': 'Green Milk Turf',
      'icon': Icons.grass,
      'color': Colors.green,
      'image': 'assets/volleyball.jpg',
    },
    {
      'name': 'Football Turf',
      'icon': Icons.sports_soccer,
      'color': Colors.red,
      'image': 'assets/volleyball.jpg',
    },
    {
      'name': 'Net Practice Turf',
      'icon': Icons.sports_cricket,
      'color': Colors.orange,
      'image': 'assets/crickettruf.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..forward();

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 4,
          shadowColor: Colors.black26,

          centerTitle: false,

          titleSpacing: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Menu',
            ),
          ),

          title: const Text(
            'LearnFort Sports Park',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),

        drawer: const DrawerMenu(),
        body: CustomScrollView(
          slivers: [
            /// 🔹 Banner Section
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 210,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      enableInfiniteScroll: true,
                      scrollPhysics: const BouncingScrollPhysics(),
                    ),
                    items: _banners.map((banner) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(
                                gameName: banner['name']!,
                                imagePath: banner['image']!,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                banner['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.iconLightColor.withOpacity(
                                    0.2,
                                  ),
                                  child: const Icon(Icons.sports, size: 100),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
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
                                  banner['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        offset: Offset(1, 1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            /// 🔹 Section Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Icon(
                      Icons.sports_soccer,
                      color: AppColors.bluePrimaryDual,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Available Turfs',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 Turf Cards
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final turf = _turfs[index];
                  return AnimatedBuilder(
                    animation: _staggerController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          50 * (1 - _staggerController.value.clamp(0, 1)),
                        ),
                        child: Opacity(
                          opacity: _staggerController.value.clamp(0, 1),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/slot_booking',
                          arguments: turf['name'],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Image.asset(
                                turf['image'] ?? 'assets/placeholder.jpg',
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 120,
                                  width: 120,
                                  color: AppColors.bluePrimaryDual,
                                  child: Icon(
                                    turf['icon'] as IconData,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      turf['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Book your slot today!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/slot_booking',
                                  arguments: turf['name'],
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.bluePrimaryDual,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  elevation: 3,
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Book',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 4),
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
                }, childCount: _turfs.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
