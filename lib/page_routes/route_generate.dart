import 'package:flutter/material.dart';
import 'package:newsweb/page_routes/routes.dart';
import 'package:newsweb/view/auth/login.dart';
import 'package:newsweb/view/ui/home_screen.dart';
import 'package:newsweb/view/ui/web_screen/homeScreemweb.dart';
import 'package:newsweb/view/ui/web_screen/homeScreemweb.dart';
import 'package:newsweb/view/ui/web_screen/splash_Screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widgetScreen;
    switch (settings.name) {
      case Routes.loginScreen:
        widgetScreen = LoginScreen(); 
        break;
           case Routes.authCheck:
        widgetScreen = AuthCheck();
        break;
         case Routes.homeScreen:
        widgetScreen = HomeScreen();
        break;

        
    case Routes.dashBoardScreenActivity:
        widgetScreen = DashBoardScreenActivity();
        break;
      default:
        widgetScreen = LoginScreen();
    }
    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => widgetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR'),
      ),
    );
  }
}
