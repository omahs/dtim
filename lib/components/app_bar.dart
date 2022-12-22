import 'package:asyou_app/store/theme.dart';
import 'package:asyou_app/utils/screen/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'move_window.dart';

class LocalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _height;
  final String _title;
  final Widget? tools;
  final Function? onBack;
  LocalAppBar({Key? key, this.onBack, this.tools, String? title, double? height})
      : _height = height ?? 60.w,
        _title = title ?? "",
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return moveWindow(Container(
      height: _height,
      color: ConstTheme.sidebarBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 25.w,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.arrow_back,
              color: ConstTheme.sidebarText,
              size: 25.w,
            ),
            onPressed: () {
              if (onBack != null) {
                onBack!();
                return;
              }
              context.pop();
            },
          ),
          SizedBox(width: 10.w),
          Text(
            _title,
            style: TextStyle(color: ConstTheme.sidebarText, fontSize: 14.w),
          ),
          Expanded(child: Container()),
          tools != null
              ? tools!
              : SizedBox(
                  width: _height,
                  child: tools,
                ),
        ],
      ),
    ));
  }

  @override
  Size get preferredSize {
    return Size(100.sw, _height);
  }
}
