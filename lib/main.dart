import 'package:flutter/material.dart';
import 'package:login_page/login_screen.dart';
import 'package:sizer_pro/sizer.dart';

void main() {
  runApp(Sizer(builder: (context, orientation, deviceType) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }));
}
