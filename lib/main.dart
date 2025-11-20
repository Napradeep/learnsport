import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportspark/screens/about_us_screen.dart';
import 'package:sportspark/screens/admin/booking_service/booking_provider.dart';
import 'package:sportspark/screens/admin/profile_service/profile_provider.dart';
import 'package:sportspark/screens/admin/sport_provider/sports_provider.dart';
import 'package:sportspark/screens/admin_screen.dart';
import 'package:sportspark/screens/common_provider/contact_provider.dart';
import 'package:sportspark/screens/common_provider/gallery_provider.dart';
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
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
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
        '/details': (context) => DetailsScreen(sportData: {}),
        '/contact': (context) => const ContactScreen(),
        '/slot_booking': (context) => SlotBookingScreen(
          turfName: ModalRoute.of(context)!.settings.arguments as String,
          sportsId: '',
          slotAmount: '',
        ),
        '/about_us': (context) => const AboutUsScreen(),
        '/sport_game': (context) => const SportsGame(),
        '/gallery': (context) => GalleryScreen(isAdmin: false),
        '/admin': (context) => const AdminScreen(heading: ''),
      },
    );
  }
}





//somthingWent wrong please try again later.

// ***1)Home page - need full scroll
// ***2)No need to show “status-closed” sports to all pages.
// ***3)Details page too bad
// 4)Slot page - Where is Date wise Month wise concept? - Frontend 
// 5)Payment details page still having there, but I said like without login time - need to redirect login page. - front End 
// ***6)Gallery page - “token not found error” while clicking any one sport.
// 7)Contact us page - form not working. (i got error like “failed to submit enquiry”)
// =================
// 8)edit and delete option - must want a alert before doing action. (My profile la antha maathiri varalai) - Frontend
// ***9)sports update - update panrappa athe page la irunthu success aanathukapram thaan back vanthu listing page kaatanum....
// But thappa nadakuthu inga.... submit kuduthathum back vanthu romba neram kalichu updated successfully nu varuthu....
// 10)loading vachu irukaiya illaya ella Api'scalling place la um?
// Api's call panrappa ? Engaium loader action paatha maathiriye theriyala enakku....
// ***11) no need unwanted sub titles in forms. (For ex : add sports)
// 12)Add gallery la multiple image post panna try pannen.. but work aagala...
// Submit aagama error adichuduchu...
// ***13) reply - "your reply" kidaiyathu, "Admin's reply" - Frontend
// ***14) contact us - after reply need to hide reply button... - 
// 15) need status updates for contacts lists - unread status, read status 





//1.email also  unique like as mobile number  - registration 
//2***.card deatils title - text filed lenth we need to increase and full 
//3.Edit Sport -  edit not working for image
//4***,contct us page - user tapselected na dthat tap i need to refresh,
//5***.contct us page -  while comming to pend / complete user tap selected  tap loading,
//6***,contct us page  - compledted api need to check and working wrongly
//7***.manager Users - > edit , activate , deactivate and block
//8***.Manage Sports -> edit , activate , deactivate and block
//9***.Delete User in Manage Users
//10***.wher edit is ther we need to ask alert are you sure edit
//11***.in header i need to display exaclamtery symbol
//12.in Home screen -  need refresh
//13***.Sports Deatisl Screen - if nitght : half ground- 100, full ground - 200
//14***.Sportd Deatils screen - we need to create a 2 seprate box to display about deatils for 1 container and other deatils 1 container
//15.***manage gallry - youtube vidoe ned to change
//16,***Gallery Delete - after deleteding need to show proper redirection
//17.***Galley Screen - we need to show menu icons - view, delete , (remove see all)
//18.***contust us - > user list is not showing via user login 
//19**.in deatil screen if some time price na we need to display single (price  : 1000)
//20**,in deatil screen if some time price same ligiting price same na  - > Fulground (we need to display on same line and sinle line )
//21***. My Enquuries - > user we need alignment need left side 
//22***.Contact US - > while reply button i need to loading like i need 
//23***, for all screen we need to imaplement a loadinfg and submit and all  api and scenoior
//24***,book slot - > while booking time i need to get 2 more deatils (no of players , notes)
//25 ///Choose you slot type - > default day dropwown day and month load , (type + date - > single day)if user choose 
