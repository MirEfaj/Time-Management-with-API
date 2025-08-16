import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:time_management/ui/screens/sign_in_screen.dart';
import 'package:time_management/ui/screens/sign_up_screen.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:time_management/ui/widgets/screen_background.dart';

import '../../data/models/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils.dart';
import '../widgets/snack_bar_msg.dart';
import 'pin_verification_screen.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});
  static const String name = '/forgot-pass';

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool forgetPassInProgress = false;

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
                    "Provide Your Email",
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "6 digit OTP will be send to your address",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: Colors.grey,
                    ),
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

                  const SizedBox(height: 16),
                  Visibility(
                    visible: forgetPassInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      text: "Have an account? ",
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

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _recoverEmail();
    }
    //  Navigator.pushNamed(context, PinVerificationScreen.name);
  }

  void _onTapSignInButton() {
    Navigator.pushNamed(context, SignInScreen.name);
  }


    Future<void> _recoverEmail() async {
      forgetPassInProgress = true;
      setState(() {});

      String email = _emailController.text.trim();

      NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyEmailURL(email),);

      forgetPassInProgress = false;
      setState(() {});

      if (response.isSuccess) {
        showSnackBarMessage(context, response.body!['data']);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PinVerificationScreen(email: email,)));
      } else {
        showSnackBarMessage(
            context, response.errorMessage ?? "Something went wrong");
      }
    }


    @override
    void dispose() {
      _emailController.dispose();
      super.dispose();
    }
  }
