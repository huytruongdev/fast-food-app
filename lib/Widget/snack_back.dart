
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, MaterialColor red){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}