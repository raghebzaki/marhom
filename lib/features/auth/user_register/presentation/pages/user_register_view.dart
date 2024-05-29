import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:marhom/core/utils/extensions.dart';

import '../../../../../core/dependency_injection/di.dart' as di;
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_form_field.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../generated/l10n.dart';
import '../../data/models/user_register_model.dart';
import '../manager/user_register_cubit.dart';

class UserRegisterView extends StatefulWidget {
  const UserRegisterView({super.key});

  @override
  State<UserRegisterView> createState() => _UserRegisterViewState();
}

class _UserRegisterViewState extends State<UserRegisterView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.di<UserRegisterCubit>(),
      child: BlocConsumer<UserRegisterCubit, UserRegisterStates>(
        listener: (context, state) {
          UserRegisterCubit registerCubit = UserRegisterCubit.get(context);
          state.maybeWhen(
            success: (state) {
              UserRegisterCubit registerCubit = UserRegisterCubit.get(context);
              if (state.status == 200) {
                context.defaultSnackBar(
                  "${state.phone} registered successfully, now redirecting you to the app",
                  color: AppColors.successGreen,
                  textColor: AppColors.blackText,
                );
              } else if (state.status == 400 || state.status == 422) {
                registerCubit.displayErrors(state.error!, context);
              }
            },
            error: (failure) {
              context.defaultSnackBar(
                S.of(context).error(failure.code.toString(), failure.message),
                color: AppColors.errorRed,
              );
            },
            checkFailed: (failure) {
              context.defaultSnackBar(
                S.of(context).error(failure.code.toString(), failure.message),
                color: AppColors.errorRed,
              );
            },
            checkSuccess: (state) {
              if (state.status == 1) {
                registerCubit.whatsappCtrl.sink
                    .addError("This number is already registered");
                registerCubit.isRegistered = true;
              } else if (state.status == 0) {
                registerCubit.whatsappCtrl.sink
                    .add(registerCubit.whatsappCtrl.value);
                registerCubit.isRegistered = false;
              }
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          UserRegisterCubit registerCubit = UserRegisterCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.p16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(50.h),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              AppImages.leafSvg,
                              height: 80.h,
                            ),
                            Text(
                              S.of(context).marhom,
                              style: CustomTextStyle.kTextStyleF26,
                            ),
                          ],
                        ),
                      ),
                      Gap(20.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: S.of(context).createNewAccount,
                              style: CustomTextStyle.kTextStyleF16,
                            ),
                            const TextSpan(text: " "),
                            TextSpan(
                              text: S.of(context).user,
                              style: CustomTextStyle.kTextStyleF16.copyWith(
                                color: AppColors.redText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(20.h),
                      Row(
                        children: [
                          Flexible(
                            child: CustomFormField(
                              stream: registerCubit.firstNameStream,
                              onChanged: (firstName) {
                                registerCubit.validateFirstName(firstName);
                              },
                              label: S.of(context).firstName,
                              keyboardType: TextInputType.text,
                              nextAction: TextInputAction.next,
                            ),
                          ),
                          Gap(10.w),
                          Flexible(
                            child: CustomFormField(
                              stream: registerCubit.lastNameStream,
                              onChanged: (lastName) {
                                registerCubit.validateLastName(lastName);
                              },
                              label: S.of(context).lastName,
                              keyboardType: TextInputType.text,
                              nextAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      Gap(10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CountryCodePicker(
                            padding: EdgeInsets.zero,
                            initialSelection: "SA",
                            favorite: const ["+966", "SA"],
                            onChanged: (code) {
                              registerCubit.dialCode = code.dialCode!;
                            },
                            textStyle: CustomTextStyle.kTextStyleF12,
                          ),
                          Expanded(
                            child: CustomFormField(
                              stream: registerCubit.whatsappStream,
                              onChanged: (waNumber) {
                                registerCubit.validateWaNumber(waNumber);
                              },
                              label: S.of(context).whatsappNumber,
                              keyboardType: TextInputType.phone,
                              nextAction: TextInputAction.next,
                              preIcon: Padding(
                                padding: const EdgeInsets.all(Dimensions.p8),
                                child: SvgPicture.asset(
                                  AppImages.whatsappLogoSvg,
                                  height: 16.h,
                                  width: 16.w,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(10.h),
                      CustomFormField(
                        stream: registerCubit.snapChatStream,
                        onChanged: (snapChatId) {
                          registerCubit.validateSnapChatId(snapChatId);
                        },
                        label: S.of(context).snapChatId,
                        keyboardType: TextInputType.text,
                        nextAction: TextInputAction.done,
                        preIcon: Padding(
                          padding: const EdgeInsets.all(Dimensions.p8),
                          child: SvgPicture.asset(
                            AppImages.snapchatLogoSvg,
                            height: 16.h,
                            width: 16.w,
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: registerCubit.registerBtnStream,
                        builder: (context, snapshot) {
                          return ConditionalBuilder(
                            condition: state is! Loading,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(Dimensions.p16),
                                child: CustomBtn(
                                  label: S.of(context).createNewAccount,
                                  onPressed: snapshot.hasError
                                      ? null
                                      : () {
                                          registerCubit.isRegistered
                                              ? null
                                              : registerCubit.userRegister(
                                                  UserRegisterModel(
                                                    firstName: registerCubit
                                                        .firstNameCtrl.value,
                                                    lastName: registerCubit
                                                        .lastNameCtrl.value,
                                                    phone:
                                                        "${registerCubit.dialCode}${registerCubit.whatsappCtrl.value}",
                                                    snapChatId: registerCubit
                                                        .snapChatCtrl.value,
                                                  ),
                                                );
                                        },
                                ),
                              );
                            },
                            fallback: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryGold,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       S.of(context).alreadyHaveAnAccount,
                      //       style: CustomTextStyle.kTextStyleF16.copyWith(
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {},
                      //       child: Text(
                      //         S.of(context).login,
                      //         style: CustomTextStyle.kTextStyleF16.copyWith(
                      //           fontWeight: FontWeight.w700,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
