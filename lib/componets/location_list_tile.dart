import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LocationListTile extends StatelessWidget {
  final String location;
  final VoidCallback press;

  const LocationListTile({super.key, required this.location, required this.press});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: Icon(Icons.navigation),
          title: Text(location, maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: Assets.fontsPoppinsRegular, color: AppColors.whiteColor),),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: AppColors.lightGrey,
        )
      ],
    );
  }
}
