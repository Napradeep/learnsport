import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/about_us_screen.dart';
import 'package:sportspark/screens/admin_screen.dart';
import 'package:sportspark/screens/contact_screen.dart';
import 'package:sportspark/screens/details_screen.dart';
import 'package:sportspark/screens/gallery_screen.dart';
import 'package:sportspark/screens/home_screen.dart';
import 'package:sportspark/screens/login/provider/auth_provider.dart';
import 'package:sportspark/screens/payment_screen.dart';
import 'package:sportspark/screens/slot_booking_screen.dart';
import 'package:sportspark/screens/sports_game.dart';
import 'package:sportspark/utils/router/router.dart';
import 'package:sportspark/utils/snackbar/snackbar.dart';
import 'package:sportspark/utils/view/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        ),
        '/payment': (context) => const PaymentScreen(),
        '/about_us': (context) => const AboutUsScreen(),
        '/sport_game': (context) => const SportsGame(),
        '/gallery': (context) => const GalleryScreen(),
        '/admin': (context) => const AdminScreen(),
      },
    );
  }
}
