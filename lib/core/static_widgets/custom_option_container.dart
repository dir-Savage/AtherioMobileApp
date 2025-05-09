import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../const/colors.dart';
import 'custom_text.dart';


class CustomOptionContainer extends StatelessWidget implements PreferredSizeWidget {
  final String? title , imagePath;
  final Function onTap;
  final double? height , width;

  const CustomOptionContainer({
    super.key,
    required this.title,
    required this.onTap,
    this.imagePath,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: height?.h ?? 34.h,
        width: width?.h ?? 95.w ,
        decoration: BoxDecoration(
          color: C.silver,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 1),
            ),
          ],
          border: Border.all(color: C.greyCont , width: 1.5.w),
        ),
        child: Row(
          children: [
            SizedBox(width: 6.w),
            SvgPicture.asset(imagePath ?? " ", width: 20.w ,height: 20.w,),
            SizedBox(width: 6.w ),
            Center(
              child: CustomText(
                text : title ?? '',
                fontSize: 11.5.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(110.h);
}
