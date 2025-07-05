import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../utls/callbacks.dart';
import '../../utls/font_sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onBackTap;
  final bool showBackArrow;
  final Color? backgroundColor;
  final List<Widget>? actionWidgets;

  const CustomAppBar({super.key,
    required this.title,
    this.onBackTap,
    this.showBackArrow = true,
    this.backgroundColor = kWhiteColor,
    this.actionWidgets
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: showBackArrow ? IconButton(
        // icon: SvgPicture.asset('assets/svgs/back_arrow.svg'),
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          if (onBackTap != null) {
            onBackTap!();
          } else {
            Navigator.of(context).pop();
          }
        },
      ) : null,
      actions: actionWidgets,
      title: Row(
        children: [
          buildText(text:  title,color:  kBlackColor,fontSize:  textMedium,fontWeight:  FontWeight.w500,
             textAlign:  TextAlign.start),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}