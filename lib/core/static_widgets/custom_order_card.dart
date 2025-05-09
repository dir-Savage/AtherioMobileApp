import 'package:atherio/core/const/colors.dart';
import 'package:atherio/core/static_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/dimentions.dart';

class CustomOrderCard extends StatelessWidget {
  const CustomOrderCard({
    super.key,
    required this.orderNumber,
    required this.itemsCount,
    required this.senderName,
    required this.recipientName,
    required this.orderStatus,
    this.tampsTime,
    required this.isToggled,
    required this.isSelected,
    required this.onToggle,
  });

  final int? orderNumber, itemsCount;
  final String? senderName, recipientName, orderStatus, tampsTime;
  final bool? isToggled, isSelected;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isSelected!),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: C.greyCont, width: 1.8.sp),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(),
              Dimensions.spaceMedium,
              _buildOrderDetails(),
              Dimensions.spaceLarge,
              _buildSenderRecipientInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      children: [
        CustomText(
          text: "${orderNumber ?? 0}",
          fontSize: 16.sp,
          isBold: true,
        ),
        const Spacer(),
        isToggled!
            ? Icon(isSelected! ? Icons.check_circle : Icons.circle_outlined,
                color: C.primaryColor, size: 20.sp)
            : Container(
                decoration: BoxDecoration(
                  color: C.greyCont,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
                child: Center(
                  child: CustomText(
                    text: orderStatus ?? "unKnown State",
                    fontSize: 14.sp,
                    color: C.greyTextTwo,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Row(
      children: [
        CustomText(
          text: tampsTime ?? "unKnown Date",
          fontSize: 12.5.sp,
          color: C.greyTextTwo,
        ),
        const Spacer(),
        Row(
          children: [
            CustomText(
              text: "Items: ",
              fontSize: 13.sp,
              color: C.greyTextTwo,
            ),
            CustomText(
              text: "${itemsCount ?? 0}",
              fontSize: 13.sp,
              color: C.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSenderRecipientInfo() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: C.greyCont,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Sender : ",
                  fontSize: 12.sp,
                  color: C.greySupText,
                ),
                CustomText(
                  text: senderName ?? "IEL",
                  fontSize: 12.sp,
                  color: C.greyTextTwo,
                  isBold: true,
                ),
              ],
            ),
          ),
          // SvgPicture.asset(
          //   ImagesCP.toSahm,
          //   width: 35.w,
          //   height: 35.w,
          // ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Recipient : ",
                  fontSize: 12.sp,
                  color: C.greySupText,
                ),
                CustomText(
                  text: recipientName ?? "IEL",
                  fontSize: 12.sp,
                  color: C.greyTextTwo,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}