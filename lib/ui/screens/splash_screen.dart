import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_management/data/controllers/auth_controller.dart';
import 'package:time_management/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:time_management/ui/utils/asset_paths.dart';
import '../widgets/screen_background.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    _moveToNextScreen();
    super.initState();
  }

  Future<void> _moveToNextScreen() async{
    await Future.delayed(Duration(seconds: 2));
    bool isLoggedIn = await AuthController.isUserLoggedIn();
    if(isLoggedIn){
      Navigator.pushReplacementNamed(context, MainNavBarHolderScreen.name);
    }else{
      Navigator.pushReplacementNamed(context, SignInScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AssetPaths.logoSVG,)),
      ),
    );
  }
}
