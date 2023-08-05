import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_dumy/firebase_options.dart';
import 'package:instagram_dumy/screens/login_screen.dart';
import 'package:instagram_dumy/screens/main_user_screen.dart';
import 'package:instagram_dumy/services/shared_preference.dart';
import 'package:instagram_dumy/providers/user_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // For Locking the Orientation of our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool userlogedin = false;
  bool userconnection = false;

  @override
  void initState() {
    super.initState();
    userlogedinstatus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Userdataprovider>(
          create: (context) => Userdataprovider(),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
              primaryColor: mobileBackgroundColor,
              scaffoldBackgroundColor: mobileBackgroundColor,
            ),
            home: userlogedin ? const MainUserScreen() : const Loginscreen(),
          );
        },
      ),
    );
  }

  userlogedinstatus() async {
    await Sharedprefference.getuserlogein().then(
      (value) => value != null ? setState(() => userlogedin = value) : false,
    );
  }
}
