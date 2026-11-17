import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

BottomNavigationBarItem bottomBarItem({
  required String activeIcon,
  required String inactiveIcon,
}) {
  return BottomNavigationBarItem(
    activeIcon: SizedBox(
      width: 90,
      height: 40,
      child: Center(
        child: SvgPicture.asset(
          activeIcon,
          height: 26,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    ),
    icon: SvgPicture.asset(
      inactiveIcon,
      colorFilter: ColorFilter.mode(
        lightColorScheme.onSecondary,
        BlendMode.srcIn,
      ),
    ),
    label: '',
  );
}
