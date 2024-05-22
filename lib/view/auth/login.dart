import 'package:flutter/material.dart';
import 'package:newsweb/view/ui/mobile/loagin.dart';
import 'package:newsweb/view/ui/web_screen/web_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
  final isSmallScreen = MediaQuery.of(context).size.width < 600;
   
    return Scaffold(
      body: isSmallScreen?MobileLoginScreen(): WebLoginScreen()
  
    );
  }
}
