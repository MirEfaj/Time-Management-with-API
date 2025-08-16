import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:time_management/data/controllers/auth_controller.dart';
import 'package:time_management/data/models/user_model.dart';
import 'package:time_management/data/service/network_caller.dart';
import 'package:time_management/ui/screens/sign_up_screen.dart';
import 'package:time_management/ui/widgets/screen_background.dart';
import '../../data/utils.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_msg.dart';
import 'forgot_password_email_screen.dart';
import 'main_nav_bar_holder_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool signInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: "Email"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!EmailValidator.validate(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: "Password"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: signInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSignInSubmitButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: _onTapForgotPassButton,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                        color: Colors.black,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: const TextStyle(
                            color: Colors.green,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _onTapSignUpButton,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async{
    signInProgress = true;
    setState(() {});
    Map<String, String> requestBody = {
      "email":_emailController.text.trim(),
      "password":_passwordController.text
    };
    NetworkResponse response = await NetworkCaller.postRequest(url: Urls.loginURL, body: requestBody, isFromLogIn: true);
    signInProgress = false;
    setState(() {});
    if(response.isSuccess){
      UserModel userModel = UserModel.fromJson(response.body?["data"]);
      String token = response.body!["token"];
      await AuthController.saveUserData(userModel, token );
      Navigator.pushNamedAndRemoveUntil(context, MainNavBarHolderScreen.name, (predicate)=>false);
    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }


  }


  void _onTapSignUpButton() {
    Navigator.pushNamed(context, SignUpScreen.name);
  }

  void _onTapForgotPassButton() {
   Navigator.pushNamed(context, ForgotPassScreen.name);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
