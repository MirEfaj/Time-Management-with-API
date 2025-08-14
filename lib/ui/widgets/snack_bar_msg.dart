import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String msg){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}