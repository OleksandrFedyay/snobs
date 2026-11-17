import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.user,
    this.radius = 82,
    super.key,
    this.fontSize,
    this.padding = const EdgeInsets.all(4),
    this.borderColor,
    this.backgroundColor,
    this.fontColor,
  });

  final double radius;
  final double? fontSize;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final UserModel? user;
  final Color? backgroundColor;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = user?.imageUrl ?? '';
    if (imageUrl.isNotEmpty) {
      return Container(
        key: ValueKey<String>(imageUrl),
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? lightColorScheme.main,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: ClipOval(
          child: SizedBox.fromSize(
            size: Size.fromRadius(radius),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
              placeholder: (BuildContext context, String url) =>
                  const CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    final String? text = user?.name?.split(' ').map((String word) {
      return word.isEmpty ? '' : word[0];
    }).join();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? lightColorScheme.main,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? lightColorScheme.secondary,
        child: Text(
          (text?.isEmpty ?? true) ? '?' : text?.toUpperCase() ?? '?',
          style: TextStyle(
            fontSize: fontSize ?? 66,
            fontWeight: FontWeight.w300,
            color: fontColor ?? lightColorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
