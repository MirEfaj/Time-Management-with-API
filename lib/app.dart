import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/screens/add_new_task_screen.dart';
import 'ui/screens/change_password_screen.dart';
import 'ui/screens/forgot_password_email_screen.dart';
import 'ui/screens/main_nav_bar_holder_screen.dart';
import 'ui/screens/pin_verification_screen.dart';
import 'ui/screens/sign_in_screen.dart';
import 'ui/screens/sign_up_screen.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/update_profile_screen.dart';

class TimeManagement extends StatelessWidget {
  const TimeManagement({super.key});
  static  GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigator,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey.shade300,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8,),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              fixedSize:Size.fromWidth(double.maxFinite),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
          ),
        )
      ),
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name : (context) => SplashScreen(),
        SignInScreen.name: (context) => SignInScreen(),
        SignUpScreen.name: (context) => SignUpScreen(),
        ForgotPassScreen.name: (context) => ForgotPassScreen(),
      //  PinVerificationScreen.name: (context) => PinVerificationScreen(email: '',),
      //  ChangePassScreen.name: (context) => ChangePassScreen(),
        MainNavBarHolderScreen.name: (context) => MainNavBarHolderScreen(),
        AddNewTaskScreen.name: (context) => AddNewTaskScreen(),
        UpdateProfileScreen.name: (context) => UpdateProfileScreen(),
      },
    );
  }
}
