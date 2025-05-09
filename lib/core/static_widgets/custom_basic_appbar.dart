import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const/colors.dart';
import 'custom_text.dart';


class CustomBasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomBasicAppbar({
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
              IconButton(
                  color: C.primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                  ),
              ),
              const Spacer(),
              CustomText(text: title , fontSize: 14.sp,),
              const Spacer(),
              SizedBox(width: 30.w,)
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(110.h);
}
