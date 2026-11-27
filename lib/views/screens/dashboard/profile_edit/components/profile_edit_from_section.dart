// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/screens/address/screen/address_screen.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/opt_verification_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class ProfileEditFormSection extends StatefulWidget {
  const ProfileEditFormSection({
    super.key,
  });

  @override
  State<ProfileEditFormSection> createState() => _ProfileEditFormSectionState();
}

class _ProfileEditFormSectionState extends State<ProfileEditFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyNumber = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Edit Profile",
                    style: Helper(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                  ),
                  const SizedBox(height: 16),
                  AppTextFieldWithHeading(
                    controller: authController.firstNameController,
                    hindText: "Enter a first name",
                    heading: "First Name",
                    bgColor: white,
                    borderColor: black,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter first name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 9),
                  AppTextFieldWithHeading(
                    controller: authController.lastNameController,
                    hindText: "Enter a Last name",
                    heading: "Last Name",
                    bgColor: white,
                    borderColor: black,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter last name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 9),
                  AppTextFieldWithHeading(
                    controller: authController.emailController,
                    hindText: "Enter a email",
                    heading: "Email",
                    bgColor: white,
                    borderColor: black,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }
                      if (!value.isEmail) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 9),
                  AppTextFieldWithHeading(
                    controller: authController.birthdayCodeController,
                    hindText: "dd-mm-yyyy",
                    hintStyle: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: greyBillText),
                    heading: "Date of Birth",
                    bgColor: white,
                    borderColor: black,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: getDateTime(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: primaryColor,
                                onPrimary: white,
                                onSurface: black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}-"
                            "${pickedDate.month.toString().padLeft(2, '0')}-"
                            "${pickedDate.year}";

                        authController.birthdayCodeController.text =
                            formattedDate;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select date of birth";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomDropDownList<String>(
                    value: authController.gender,
                    items: authController.genderList ?? [],
                    hintText: "Gender",
                    hintStyle: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: greyBillText),
                    bgColor: white,
                    borderColor: black,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select gender';
                      }
                      return null;
                    },
                    onChanged: (v) async {
                      authController.setGender(value: v ?? "");
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: CustomButton(
                      isLoading: authController.isLoading,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          authController.updateProfile().then((value) {
                            if (value.isSuccess) {
                              pop(context);
                              showToast(
                                  message: value.message,
                                  typeCheck: value.isSuccess);
                            } else {
                              showToast(
                                  message: value.message,
                                  typeCheck: value.isSuccess);
                            }
                          });
                        }
                      },
                      radius: 100,
                      child: Text(
                        "Update Profile",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                              color: white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKeyNumber,
                    child: AppTextFieldWithHeading(
                      controller: authController.numberController,
                      hindText: "Enter a phone number",
                      heading: "Phone Number",
                      bgColor: white,
                      borderColor: black,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      suffix: TextButton(
                          onPressed: () {
                            if (_formKeyNumber.currentState?.validate() ??
                                false) {
                              if (authController.numberController.text !=
                                  authController.userModel?.mobile) {
                                navigate(
                                  context: context,
                                  page: OTPVerification(
                                    phone: authController.numberController.text
                                        .trim(),
                                    isUpdateNumber: true,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Update",
                            style:
                                Helper(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter phone number";
                        }
                        if (value.length != 10) {
                          return "Please enter valid phone number";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => navigate(context: context, page: const AddressScreen()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: primaryColor, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery & Saved Addresses",
                                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "Add or manage your delivery locations",
                                  style: Helper(context).textTheme.bodySmall?.copyWith(
                                    color: greyAccountText,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_sharp, color: greyAccountText, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.campaign_outlined, color: primaryColor, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Marketing & Promotional Consent",
                                style: Helper(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Receive promotional updates, exclusive deals, and discount offers through SMS, Email and WhatsApp. You can grant or withdraw this consent anytime.",
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                color: greyAccountText,
                                fontSize: 11,
                                height: 1.4,
                              ),
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: primaryColor,
                          title: const Text(
                            "Promotional Updates (SMS, Email, WhatsApp)",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          subtitle: Text(
                            (authController.userModel?.marketingConsent ?? false)
                                ? "Status: Opted-In (Active)"
                                : "Status: Withdrawn / Opted-Out",
                            style: TextStyle(
                              fontSize: 11,
                              color: (authController.userModel?.marketingConsent ?? false)
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: authController.userModel?.marketingConsent ?? false,
                          onChanged: (val) async {
                            final res = await authController.updateMarketingConsent(val);
                            showToast(
                              message: res.message,
                              typeCheck: res.isSuccess,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
