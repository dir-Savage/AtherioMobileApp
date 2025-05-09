import 'package:atherio/core/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/dimentions.dart';
import 'custom_text.dart';


class NormalCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const NormalCustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: C.silver,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Row(
            children: [
             // SvgPicture.asset(BasicIcons.profile),
              SizedBox(width: 8.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Welcome Back ," , fontSize: 11.sp, color: C.greyText,),
                  CustomText(text: "Bashar Rizk" , fontSize: 12.sp,),
                ],
              ),
              Spacer(),
              //SvgPicture.asset(LogoIcons.smallLogo, width: 28.sp, height: 28.sp,),
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(110.h);
}
