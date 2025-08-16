import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:time_management/data/controllers/auth_controller.dart';
import 'package:time_management/data/models/user_model.dart';
import 'package:time_management/data/service/network_caller.dart';
import 'package:time_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:time_management/ui/widgets/screen_background.dart';
import 'package:time_management/ui/widgets/snack_bar_msg.dart';
import '../../data/utils.dart';
import '../widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailController = TextEditingController(text: AuthController.userModel?.email ?? "");
  final TextEditingController _firstNameController = TextEditingController(text: AuthController.userModel?.firstName ?? "");
  final TextEditingController _lastNameController = TextEditingController(text: AuthController.userModel?.lastName ?? "");
  final TextEditingController _phoneController = TextEditingController(text: AuthController.userModel?.mobile ?? "");
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool updateProfileInProgress = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tmAppBar(),
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
                  const SizedBox(height: 30),
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: _onTapToSelectProfile,
                    child: Container(
                      height: 50,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 100,
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: Text("Photo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                            ),
                            SizedBox(width: 15,),
                            Text(_selectedImage == null ? "Select Image" : _selectedImage!.name,
                            maxLines: 2,
                            style: TextStyle(overflow: TextOverflow.ellipsis),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    enabled: false,
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
                      } else if (value.length < 11) {
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
                      int length = value?.length ?? 0;
                      if (length >0 && length <=6 ) {
                        return "Password must be 6 or more than digit";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  Visibility(
                    visible: updateProfileInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
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

  Future<void> _onTapToSelectProfile() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
        source:ImageSource.camera );
    if(pickedImage !=null){
      _selectedImage = pickedImage;
      setState(() { });


    }

  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  Future<void> _updateProfile() async{
    updateProfileInProgress = true;
    if(mounted){
      setState(() { });
    }

    Uint8List? imageBytes;

    Map<String, String> resquestBody= {
      "email":_emailController.text,
      "firstName":_firstNameController.text.trim(),
      "lastName":_lastNameController.text.trim(),
      "mobile":_phoneController.text.trim(),
    };
    if(_passwordController.text.isNotEmpty){
      resquestBody["password"] = _passwordController.text;
    }
    if(_selectedImage != null){
       imageBytes = await _selectedImage!.readAsBytes();
      resquestBody["photo"] = base64Encode(imageBytes);
    }
    NetworkResponse response = await NetworkCaller.postRequest(url: Urls.updateProfileURL, body: resquestBody);

    updateProfileInProgress = false;
    if(mounted){
      setState(() { });
    }

    if(response.isSuccess){
      UserModel usesModel = UserModel(
          id: AuthController.userModel!.id,
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          mobile: _phoneController.text.trim(),
          photo: imageBytes == null
              ? AuthController.userModel!.photo
              : base64Encode(imageBytes),
      );
      await AuthController.updateUserData(usesModel);
      _passwordController.clear();
      if(mounted){
        showSnackBarMessage(context, "Profile Updated");
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
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
