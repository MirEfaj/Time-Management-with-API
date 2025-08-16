import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_management/ui/screens/sign_in_screen.dart';

import '../../data/controllers/auth_controller.dart';
import '../screens/update_profile_screen.dart';

class tmAppBar extends StatefulWidget implements PreferredSizeWidget{
  const tmAppBar({
    super.key,
  });

  @override
  State<tmAppBar> createState() => _tmAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _tmAppBarState extends State<tmAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: ListTile(
        leading: GestureDetector(
            onTap: _onTapProfileScreen,
            child: CircleAvatar(
              backgroundImage: AuthController.userModel?.photo == null
                  ? null
                  : MemoryImage(base64Decode(AuthController.userModel!.photo.toString()),),

            )),
        title: Text(AuthController.userModel!.fullName,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
        subtitle: Text(AuthController.userModel!.email,style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),),
        trailing: IconButton(onPressed: _onTapLogOutButton, icon: Icon(Icons.logout_outlined)),
      ),);
  }

Future<void> _onTapLogOutButton() async{
    await AuthController.clearData();
    Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);
}

void _onTapProfileScreen(){
    if(ModalRoute.of(context)!.settings.name != UpdateProfileScreen.name ){
      Navigator.pushNamed(context, UpdateProfileScreen.name);
    }else{

    }

}

}