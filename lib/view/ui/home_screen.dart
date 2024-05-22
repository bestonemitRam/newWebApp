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
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    title: Text('Admin '),
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState?.openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: AppHelper.themelight
                            ? AppHelper.themelight
                                ? Colors.white
                                : Colors.black
                            : Colors.black,
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
                    builder: (context, child) {
                      switch (_controller.selectedIndex) {
                        case 0:
                          _key.currentState?.closeDrawer();
                          return HomeScreen();
                        case 1:
                          _key.currentState?.closeDrawer();
                          return Center(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                  color: AppHelper.themelight
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 40),
                            ),
                          );
                        case 2:
                          _key.currentState?.closeDrawer();
                          return Center(
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                  color: AppHelper.themelight
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 40),
                            ),
                          );
                        case 3:
                          _key.currentState?.closeDrawer();
                          return Center(
                            child: Text(
                              'Theme',
                              style: TextStyle(
                                  color: AppHelper.themelight
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 40),
                            ),
                          );
                        default:
                          return Center(
                            child: Text(
                              'Home',
                              style: TextStyle(
                                  color: AppHelper.themelight
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 40),
                            ),
                          );
                      }
                    },
                  ),
                ))
              ],
            ));
      }),
    );
  }
}

class SideBarXExample extends StatelessWidget {
  const SideBarXExample({Key? key, required SidebarXController controller})
      : _controller = controller,
        super(key: key);
  final SidebarXController _controller;
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        decoration: BoxDecoration(
            color: canvasColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        iconTheme: IconThemeData(
          color: AppHelper.themelight
              ? AppHelper.themelight
                  ? Colors.white
                  : Colors.black
              : Colors.black,
        ),
        selectedTextStyle: TextStyle(
            color: AppHelper.themelight
                ? AppHelper.themelight
                    ? Colors.white
                    : Colors.black
                : Colors.black),
      ),
      extendedTheme: SidebarXTheme(width: 250),
      footerDivider: Divider(
          color: AppHelper.themelight
              ? Colors.white
              : Colors.black.withOpacity(0.8),
          height: 1),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Icon(
            Icons.person,
            size: 60,
            color: AppHelper.themelight
                ? AppHelper.themelight
                    ? Colors.white
                    : Colors.black
                : Colors.black,
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
        ),
        SidebarXItem(
          icon: Icons.search,
          label: 'Search',
        ),
        SidebarXItem(icon: Icons.settings, label: 'Setting'),
        SidebarXItem(icon: Icons.dark_mode, label: 'Light/Dark Mode'),
      ],
    );
  }
}
