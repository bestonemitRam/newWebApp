import 'package:flutter/material.dart';
import 'package:newsweb/utils/apphelper.dart';
import 'package:newsweb/view/ui/web_screen/add_video.dart';
import 'package:newsweb/view/ui/web_screen/homeScreemweb.dart';
import 'package:newsweb/view/ui/web_screen/side_menu.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:flutter/material.dart';
import 'package:newsweb/utils/apphelper.dart';
import 'package:newsweb/view/ui/web_screen/homeScreemweb.dart';
import 'package:sidebarx/sidebarx.dart';

class DashBoardScreenActivity extends StatefulWidget {
  const DashBoardScreenActivity({Key? key}) : super(key: key);

  @override
  _DashBoardScreenActivityState createState() =>
      _DashBoardScreenActivityState();
}

const primaryColor = Color(0xFF6252DA);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF7777B6);

class _DashBoardScreenActivityState extends State<DashBoardScreenActivity> {
  final SidebarXController _controller =
      SidebarXController(selectedIndex: 0, extended: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context)
   {
    return SafeArea(
      child: Builder(builder: (context) 
      {
        final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Scaffold(
          key: _scaffoldKey,
          appBar: isSmallScreen
              ? AppBar(
                  title: Text('Admin'),
                  leading: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                      color: AppHelper.themelight ? Colors.white : Colors.black,
                    ),
                  ),
                )
              : null,
          drawer: SideBarXExample(
            controller: _controller,
          ),
          body: Row(
            children: [
              if (!isSmallScreen) SideBarXExample(controller: _controller),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) 
                    {
                     

                      switch (_controller.selectedIndex) {
                        case 0:
                          _scaffoldKey.currentState?.closeDrawer();
                          return HomeScreen();
                        case 1:
                          _scaffoldKey.currentState?.closeDrawer();
                          return 
                         AddVideo();

                        default:
                          return HomeScreen();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
      ),
    );
  }
}
