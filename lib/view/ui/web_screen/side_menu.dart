import 'package:flutter/material.dart';
import 'package:newsweb/utils/apphelper.dart';
import 'package:newsweb/view/ui/home_screen.dart';
import 'package:sidebarx/sidebarx.dart';

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
            bottomRight: Radius.circular(20),
          ),
        ),
        iconTheme: IconThemeData(
          color: AppHelper.themelight ? Colors.white : Colors.black,
        ),
        selectedTextStyle: TextStyle(
          color: AppHelper.themelight ? Colors.white : Colors.black,
        ),
      ),
      extendedTheme: SidebarXTheme(width: 250),
      footerDivider: Divider(
        color:
            AppHelper.themelight ? Colors.white : Colors.black.withOpacity(0.8),
        height: 1,
      ),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Icon(
            Icons.person,
            size: 60,
            color: AppHelper.themelight ? Colors.white : Colors.black,
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Add News',
        ),
        SidebarXItem(
          icon: Icons.video_camera_back_outlined,
          label: 'Add Video',
        ),
      ],
    );
  }
}
