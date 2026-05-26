import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  /// OPTIONAL
  final bool showArrow;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,

    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: Container(
        width: 46,
        height: 46,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),

          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        ),

        child: Center(child: icon),
      ),

      title: Text(
        title,

        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),

      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios_rounded, size: 18)
          : null,

      onTap: onTap,
    );
  }
}
