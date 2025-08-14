

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:time_management/ui/screens/sign_in_screen.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_msg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool signUiInProgress = false;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Join With Us",
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
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(hintText: "First Name"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "First Name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(hintText: "Last Name"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Your Last Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(hintText: "Phone"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Your Phone Number";
                      } else if (value.length <= 10) {
                        return "Password must be 11 digit";
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
                      if (value == null || value.isEmpty || value.length < 7) {
                        return "Password must be 6 or more than digit";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  Visibility(
                    visible: signUiInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSignUpButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Center(
                    child: RichText(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
    print("========sign up button=======");
    if (_formKey.currentState!.validate()) {
      print("========sign up button=== validate====");
      _signUp();
    }
  }

  Future<void> _signUp() async{
    signUiInProgress = true;
    setState(() {});
    Map<String , String> requestBody = {
      "email":_emailController.text.trim(),
      "firstName":_firstNameController.text.trim(),
      "lastName":_lastNameController.text.trim(),
      "mobile":_phoneController.text.trim(),
      "password":_passwordController.text,
    };
    NetworkResponse response = await NetworkCaller.postRequest(url: Urls.registrationURL, body:requestBody );
    signUiInProgress = false;
    setState(() {});
    if(response.isSuccess){
      Navigator.pushNamed(context, SignInScreen.name);
      showSnackBarMessage(context, "Registration has been success. Please logIn");
      _clearTextFields();
    }else{
      showSnackBarMessage(context, response.errorMessage!);
    }

  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _clearTextFields(){
    _firstNameController.clear();
    _lastNameController.clear();
    _passwordController.clear();
    _emailController.clear();
    _phoneController.clear();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
