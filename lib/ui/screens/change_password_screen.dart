import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:time_management/data/service/network_caller.dart';
import 'package:time_management/ui/screens/sign_in_screen.dart';
import 'package:time_management/ui/screens/sign_up_screen.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:time_management/ui/widgets/screen_background.dart';

import '../../data/utils.dart';
import '../widgets/snack_bar_msg.dart';
import 'forgot_password_email_screen.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key, required this.email, required this.otp});
  static const String name = '/change-pass';
  final String email;
  final String otp;

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passChangeInProgress = false;

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
                    "Change Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _newPassController,
                   // obscureText: true,
                    decoration: const InputDecoration(hintText: "New Password"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPassController,
                 //   obscureText: true,
                    decoration: const InputDecoration(hintText: "Confirm Password"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Enter confirm password";
                      } else if (value != _newPassController.text) {
                        return "Confirm password doesn't match";
                      }
                      return null;
                    },

                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: passChangeInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapChangePassButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 25),
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
                          text: "Sign In",
                          style: const TextStyle(
                            color: Colors.green,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _onTapSignInButton,
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

  void _onTapSignInButton() {
    Navigator.pushNamed(context, SignInScreen.name);
  }

  void _onTapChangePassButton() {
    if (_formKey.currentState!.validate()) {
      _changePassword();
    }

  }

Future<void> _changePassword() async {
  passChangeInProgress = true;
  setState(() { });
  String email = widget.email;
  String otp = widget.otp;

  Map<String, String> requestBody= {
    "email":email,
    "OTP": otp,
    "password":_confirmPassController.text
  };
  
  NetworkResponse response = await NetworkCaller.postRequest(url: Urls.passChangeUrl, body: requestBody);
  passChangeInProgress = true;
  if(!mounted) return;
  setState(() { });

  if (response.isSuccess) {
    showSnackBarMessage(context, "Password Successfully Changed");
     // Navigator.pushNamed(context, SignInScreen.name);
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
          (route) => false,
    );

  } else {
    showSnackBarMessage(context, response.errorMessage ?? "Something went wrong");
  }
    
 
}

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }
}
