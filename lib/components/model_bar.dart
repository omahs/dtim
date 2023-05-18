import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../store/theme.dart';
import '../utils/screen/screen.dart';
import 'appicon.dart';
import 'move_window.dart';

class ModelBar extends StatelessWidget implements PreferredSizeWidget {
  final double _height;
  final String _title;
  final Widget? tools;
  final Function? onBack;
  ModelBar({Key? key, this.onBack, this.tools, String? title, double? height})
      : _height = (height ?? 55.w).toInt().toDouble(),
        _title = title ?? "",
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    final size = _height;
    return moveWindow(
      Container(
        height: _height,
        color: constTheme.sidebarHeaderBg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 15.w),
            Text(
              _title,
              style: TextStyle(color: constTheme.sidebarHeaderTextColor, fontSize: 14.w),
            ),
            Expanded(child: Container()),
            tools != null
                ? tools!
                : SizedBox(
                    width: _height,
                    child: tools,
                  ),
            IconButton(
              onPressed: () {
                if (onBack != null) {
                  onBack!();
                  return;
                }
              },
              icon: Icon(Appicon.tuopanhua, color: constTheme.sidebarHeaderTextColor, size: 17.w),
              iconSize: 17.w,
              constraints: BoxConstraints(minWidth: size, maxWidth: size, minHeight: size, maxHeight: size),
              padding: EdgeInsets.zero,
              tooltip: L10n.of(context)!.close,
              style: IconButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  // borderRadius: BorderRadius.circular(20),
                  borderRadius: BorderRadius.zero, //Rectangular border
                ),
                hoverColor: constTheme.errorTextColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size(100.sw, _height);
  }
}
