import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:marhom/core/utils/extensions.dart';

import '../../../../../core/shared/widgets/network_image_error.dart';
import '../../../../../core/shared/widgets/network_image_progressor.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/utils/dimensions.dart';
import '../widgets/language_buttom_sheet.dart';
import '../widgets/menu_tile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.p16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.r12),
                  child: CachedNetworkImage(
                    imageUrl: "${AppImages.placeholder}314x127",
                    height: 160.h,
                    width: context.queryWidth.w,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            NetworkImageProgress(
                                downloadProgress: downloadProgress),
                    errorWidget: (context, url, error) =>
                        const NetworkImageError(),
                  ),
                ),
                Gap(30.h),
                Text(
                  "Menu",
                  style: CustomTextStyle.kTextStyleF20,
                ),
                Gap(30.h),
                const MenuTile(
                  title: "Change Language",
                  children: [
                    LanguageBottomSheet(),
                  ],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Description of funeral prayers",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Condolence messages",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Numbers",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Mortality",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Fatwas & General Questions",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Profile settings",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Message to supervisor",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Contact us",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "Share app",
                  children: [],
                ),
                Gap(15.h),
                const MenuTile(
                  title: "About us",
                  children: [],
                ),
                Gap(20.h),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.p36.h,
                        vertical: Dimensions.p12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.r12),
                      border: Border.all(
                        color: AppColors.errorRed,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Logout",
                        style: CustomTextStyle.kTextStyleF18.copyWith(
                          fontWeight: FontWeight.w300,
                          color: AppColors.redText,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}