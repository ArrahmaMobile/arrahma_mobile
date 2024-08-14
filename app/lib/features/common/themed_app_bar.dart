import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/flutter_framework.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ThemedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
  });
  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final hasEmptyTitle = title == '';
    final color = hasEmptyTitle
        ? ColorUtils.getContrastColor(appTheme.theme!.colorScheme.surface)
        : Colors.white;
    return AppBar(
      centerTitle: true,
      systemOverlayStyle:
          AppUtils.isIOS && appTheme.isLightMode && hasEmptyTitle
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
      // brightness: AppUtils.isIOS && appTheme.isLightMode && hasEmptyTitle
      //     ? Brightness.light
      //     : Brightness.dark,
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(color: color),
      backgroundColor: backgroundColor ??
          (hasEmptyTitle ? appTheme.theme!.colorScheme.surface : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
