import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';

class CustomAppbarDrawer extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppbarDrawer({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: Helper(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
