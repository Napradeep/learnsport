import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/about_us_screen.dart';
import 'package:sportspark/screens/admin/booking_service/booking_provider.dart';
import 'package:sportspark/screens/admin/profile_service/profile_provider.dart';
import 'package:sportspark/screens/admin/sport_provider/sports_provider.dart';
import 'package:sportspark/screens/admin_screen.dart';
import 'package:sportspark/screens/contact_screen.dart';
import 'package:sportspark/screens/details_screen.dart';
import 'package:sportspark/screens/gallery_screen.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/login/provider/auth_provider.dart';
import 'package:sportspark/screens/search_provider/search_provider.dart';
import 'package:sportspark/screens/slot_booking_screen.dart';
import 'package:sportspark/screens/sports_game.dart';
import 'package:sportspark/screens/sportslist/sports_provider.dart';
import 'package:sportspark/utils/router/route_observer.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/view/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SportsProvider()),
        ChangeNotifierProvider(create: (_) => AddSportsProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Sports Park',
      navigatorKey: MyRouter.navigatorKey,
      scaffoldMessengerKey: Messenger.rootScaffoldMessengerKey,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/details': (context) => DetailsScreen(
          gameName: ModalRoute.of(context)!.settings.arguments as String,
          imagePath: '',
        ),
        '/contact': (context) => const ContactScreen(),
        '/slot_booking': (context) => SlotBookingScreen(
          turfName: ModalRoute.of(context)!.settings.arguments as String,
          sportsId: '',
        ),
        '/about_us': (context) => const AboutUsScreen(),
        '/sport_game': (context) => const SportsGame(),
        '/gallery': (context) => GalleryScreen(isAdmin: false),
        '/admin': (context) => const AdminScreen(heading: ''),
      },
    );
  }
}
