import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/address/screen/address_screen.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/opt_verification_screen.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/privacy_center_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/terms_conditions_screen.dart';
import 'package:lekra/views/screens/dashboard/profile_edit/profile_edit_screen.dart';
import 'package:lekra/views/screens/rewards/screen/rewards_screen/rewards_screen.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_category/subscription_category_screen.dart';
import 'package:lekra/views/screens/support/support_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/refund_policy_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/shipping_policy_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/grievance_officer_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class RowOfAccount extends StatelessWidget {
  final RowOfAccountModel rowOfAccountModel;
  const RowOfAccount({
    super.key,
    required this.rowOfAccountModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: rowOfAccountModel.onTap != null
          ? () => rowOfAccountModel.onTap!(context)
          : null,
      child: Row(
        children: [
          rowOfAccountModel.customLeading != null
              ? rowOfAccountModel.customLeading!
              : rowOfAccountModel.isSvgIcon
                  ? Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (rowOfAccountModel.iconBgColor ?? primaryColor).withValues(
                          alpha: 0.09,
                        ),
                      ),
                      child: SvgPicture.asset(
                        rowOfAccountModel.icon,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CustomImage(
                      path: rowOfAccountModel.icon,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rowOfAccountModel.title,
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: rowOfAccountModel.titleColor,
                      ),
                ),
                if (rowOfAccountModel.subTitle != null)
                  Text(
                    rowOfAccountModel.subTitle ?? "",
                    overflow: TextOverflow.clip,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: greyAccountText,
                        ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_sharp,
            color: greyAccountText,
          )
        ],
      ),
    );
  }
}

class RowOfAccountModel {
  final String title;
  final String? subTitle;
  final String icon;
  final bool isSvgIcon;
  final Color? titleColor;
  final Color? iconBgColor;
  final Widget? customLeading;
  final Function(BuildContext context)? onTap;

  RowOfAccountModel({
    required this.title,
    this.subTitle,
    this.isSvgIcon = false,
    this.icon = "",
    this.titleColor,
    this.iconBgColor,
    this.customLeading,
    required this.onTap,
  });
}

void _showDeleteAccountDialog(BuildContext context) {
  final credentialController = TextEditingController();
  final reasonController = TextEditingController();
  final hasPin = Get.find<AuthController>().userModel?.walletPinSet ?? false;

  showDialog(
    context: context,
    builder: (ctx) {
      bool isSubmitting = false;
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFDC2626), size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Are you sure you want to permanently delete your Sathiya Smart account?",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFECDD3)),
                  ),
                  child: const Text(
                    "Notice: Active memberships, unused wallet balance, reward points, and scratch cards will be permanently forfeited. This action cannot be undone.",
                    style: TextStyle(fontSize: 11, color: Color(0xFF9F1239), height: 1.4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  hasPin
                      ? "Enter 6-Digit Wallet PIN or Password:"
                      : "Enter Account Password to confirm:",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: credentialController,
                  obscureText: true,
                  keyboardType: hasPin ? TextInputType.number : TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hasPin ? "PIN or Password" : "Password",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Reason for leaving (Optional):",
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Optional reason",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                final cred = credentialController.text.trim();
                                if (cred.isEmpty) {
                                  showToast(
                                      message: hasPin
                                          ? "Please enter your Wallet PIN or Password"
                                          : "Please enter your Password",
                                      toastType: ToastType.error);
                                  return;
                                }

                                setState(() => isSubmitting = true);

                                final auth = Get.find<AuthController>();
                                final isPin = RegExp(r'^\d{4,6}$').hasMatch(cred);

                                final res = await auth.deleteAccount(
                                  pin: isPin ? cred : null,
                                  password: !isPin ? cred : null,
                                  reason: reasonController.text.trim(),
                                );

                                setState(() => isSubmitting = false);

                                if (res.isSuccess) {
                                  Navigator.pop(ctx);
                                  showToast(
                                      message: res.message,
                                      typeCheck: true);
                                  navigate(
                                    context: context,
                                    page: const LoginScreen(),
                                    isRemoveUntil: true,
                                  );
                                } else {
                                  showToast(
                                      message: res.message,
                                      toastType: ToastType.error);
                                }
                              },
                        child: isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text("Delete",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

void _showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Language / भाषा चुनें",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.language, color: primaryColor),
                title: const Text("English (Default)", style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.check_circle, color: primaryColor),
                onTap: () {
                  Navigator.pop(ctx);
                  Get.snackbar("Language", "Language set to English",
                      backgroundColor: Colors.white, colorText: Colors.black);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.translate, color: primaryColor),
                title: const Text("हिन्दी (Hindi)", style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.circle_outlined, color: Colors.grey),
                onTap: () {
                  Navigator.pop(ctx);
                  Get.snackbar("Language / भाषा", "भाषा हिन्दी में सेट की गई",
                      backgroundColor: Colors.white, colorText: Colors.black);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showNotificationBottomSheet(BuildContext context) {
  final authController = Get.find<AuthController>();
  bool pushEnabled = true;
  bool orderAlerts = true;
  bool promoOffers = authController.userModel?.marketingConsent ?? false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(builder: (context, setModalState) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notification & Marketing Settings",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  activeColor: primaryColor,
                  title: const Text("Push Notifications", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text("Receive recharge, transaction & wallet updates", style: TextStyle(fontSize: 12)),
                  value: pushEnabled,
                  onChanged: (val) => setModalState(() => pushEnabled = val),
                ),
                SwitchListTile(
                  activeColor: primaryColor,
                  title: const Text("Order & Delivery Alerts", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text("Real-time updates about your shopping orders", style: TextStyle(fontSize: 12)),
                  value: orderAlerts,
                  onChanged: (val) => setModalState(() => orderAlerts = val),
                ),
                SwitchListTile(
                  activeColor: primaryColor,
                  title: const Text("Promotional Updates (SMS, Email, WhatsApp)", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(
                    promoOffers
                        ? "Consent Active: Receiving offers & discounts"
                        : "Consent Withdrawn: No promotional updates",
                    style: TextStyle(
                      fontSize: 12,
                      color: promoOffers ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    ),
                  ),
                  value: promoOffers,
                  onChanged: (val) async {
                    setModalState(() => promoOffers = val);
                    await authController.updateMarketingConsent(val);
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      showToast(
                        message: "Your preferences have been saved successfully.",
                        typeCheck: true,
                      );
                    },
                    child: const Text("Save Preferences", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

void _showPasswordPinResetBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) {
      final mobile = Get.find<AuthController>().userModel?.mobile ?? "";
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Update Password & Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Select which credential you would like to reset via Mobile OTP verification:",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 18),
            // Option 1: Forgot / Reset Login Password
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_reset_rounded, color: Color(0xFF4F46E5), size: 22),
              ),
              title: const Text(
                "Reset Login Password (OTP)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: const Text(
                "Send OTP to registered mobile to set a new login password",
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              onTap: () {
                Navigator.pop(ctx);
                Get.find<AuthController>().generateOtp(mobile: mobile).then((val) {
                  navigate(
                    context: context,
                    page: OTPVerification(
                      phone: mobile,
                      isUpdatePassword: true,
                    ),
                  );
                });
              },
            ),
            const Divider(height: 16),
            // Option 2: Forgot / Reset Wallet PIN
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pin_rounded, color: Color(0xFF0D9488), size: 22),
              ),
              title: const Text(
                "Reset Wallet PIN (OTP)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: const Text(
                "Send OTP to registered mobile to create or reset your 6-digit Wallet PIN",
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              onTap: () {
                Navigator.pop(ctx);
                Get.find<AuthController>().generateOtp(mobile: mobile).then((val) {
                  navigate(
                    context: context,
                    page: OTPVerification(
                      phone: mobile,
                      isForResetPin: true,
                    ),
                  );
                });
              },
            ),
          ],
        ),
      );
    },
  );
}

List<RowOfAccountModel> rowOfAccountModelList = [
  RowOfAccountModel(
    title: "Edit Profile",
    subTitle: "Personal details & photo",
    icon: Assets.svgsPersonAccount,
    onTap: (context) {
      navigate(context: context, page: const ProfileEditScreen());
    },
  ),
  RowOfAccountModel(
    title: "Saved Addresses",
    subTitle: "Manage your saved Address",
    icon: Assets.svgsAddresssAccount,
    onTap: (context) {
      navigate(context: context, page: const AddressScreen());
    },
  ),
  RowOfAccountModel(
    title: "Want to Sell (Create Seller Account)",
    subTitle: "Create your seller account for app",
    icon: Assets.svgsShopping,
    isSvgIcon: true,
    onTap: (context) async {
      final user = Get.find<AuthController>().userModel;
      String targetUrl = AppConstants.vendorRegisterUrl;

      if (user != null) {
        final params = <String, String>{};
        if (user.fullName.isNotEmpty) {
          params['name'] = user.fullName;
        }
        if (user.email != null && user.email!.isNotEmpty) {
          params['email'] = user.email!;
        }
        if (user.mobile != null && user.mobile!.isNotEmpty) {
          params['mobile'] = user.mobile!;
        }
        if (user.referralCode != null && user.referralCode!.isNotEmpty) {
          params['ref'] = user.referralCode!;
        }
        if (params.isNotEmpty) {
          final uri = Uri.parse(targetUrl);
          final newQuery = Map<String, dynamic>.from(uri.queryParameters)..addAll(params);
          targetUrl = uri.replace(queryParameters: newQuery).toString();
        }
      }

      final Uri url = Uri.parse(targetUrl);

      try {
        bool launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          Get.snackbar("Error", "Could not open the website");
        }
      } catch (e) {
        debugPrint("Error: $e");
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    },
  ),
  RowOfAccountModel(
    title: "Select Language",
    subTitle: "Choose app language (English / हिन्दी)",
    icon: Assets.svgsTermsPolicies,
    onTap: (context) {
      _showLanguageBottomSheet(context);
    },
  ),
  RowOfAccountModel(
    title: "Notification Settings",
    subTitle: "Manage order, wallet and push alerts",
    icon: Assets.svgsNotification,
    isSvgIcon: true,
    onTap: (context) {
      _showNotificationBottomSheet(context);
    },
  ),
  RowOfAccountModel(
    title: "Rewards",
    subTitle: "Gain your exclusive rewards",
    icon: Assets.svgsReward,
    onTap: (context) {
      navigate(context: context, page: const RewardsScreen());
    },
  ),
  RowOfAccountModel(
    title: "Membership Subscription ",
    subTitle: "Apply for premium membership",
    icon: Assets.svgsMembershipSubscription,
    onTap: (context) {
      navigate(context: context, page: const SubscriptionCategoryPlan());
    },
  ),
  RowOfAccountModel(
    title: "Update Password & PIN",
    subTitle: "Reset login password or wallet PIN via OTP",
    icon: Assets.svgsUpdatePassword,
    isSvgIcon: true,
    onTap: (context) {
      _showPasswordPinResetBottomSheet(context);
    },
  ),
  RowOfAccountModel(
    title: "Update wallet Password",
    subTitle: "Reset wallet PIN via OTP verification",
    icon: Assets.svgsWalletPassword,
    isSvgIcon: true,
    onTap: (context) {
      _showPasswordPinResetBottomSheet(context);
    },
  ),
  RowOfAccountModel(
    title: "Help & Support",
    icon: Assets.svgsHelpSupport,
    onTap: (context) {
      navigate(context: context, page: HelpAndSupport());
    },
  ),
  RowOfAccountModel(
    title: "Privacy Center",
    subTitle: "DPDP personal data protection & privacy charter",
    icon: Assets.svgsPrivacyCenter,
    isSvgIcon: true,
    onTap: (context) {
      navigate(context: context, page: const PrivacyCenterScreen());
    },
  ),
  RowOfAccountModel(
    title: "Terms And Conditions",
    subTitle: "Platform rules, memberships & legal terms",
    icon: Assets.svgsTermsPolicies,
    onTap: (context) {
      navigate(context: context, page: const TermsAndConditionScreen());
    },
  ),
  RowOfAccountModel(
    title: "Return & Refund Policy",
    subTitle: "7-day return, refund and cancellation rules",
    icon: Assets.svgsTermsPolicies,
    customLeading: Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF16A34A).withValues(alpha: 0.1),
      ),
      child: const Icon(Icons.assignment_return_outlined, size: 20, color: Color(0xFF16A34A)),
    ),
    onTap: (context) {
      navigate(context: context, page: const RefundPolicyScreen());
    },
  ),
  RowOfAccountModel(
    title: "Shipping & Delivery Policy",
    subTitle: "Courier timelines & free delivery benefits",
    icon: Assets.svgsTermsPolicies,
    customLeading: Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
      ),
      child: const Icon(Icons.local_shipping_outlined, size: 20, color: Color(0xFF4F46E5)),
    ),
    onTap: (context) {
      navigate(context: context, page: const ShippingPolicyScreen());
    },
  ),
  RowOfAccountModel(
    title: "Grievance Redressal Officer",
    subTitle: "Statutory nodal contact (Rule 3(2) IT Rules)",
    icon: Assets.svgsTermsPolicies,
    customLeading: Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD97706).withValues(alpha: 0.1),
      ),
      child: const Icon(Icons.gavel_rounded, size: 20, color: Color(0xFFD97706)),
    ),
    onTap: (context) {
      navigate(context: context, page: const GrievanceOfficerScreen());
    },
  ),
  RowOfAccountModel(
    title: "Log out",
    subTitle: "Safely sign out from this device",
    icon: Assets.svgsLogout,
    onTap: (context) {
      Get.find<AuthController>().logout().then((value) {
        if (value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);
          navigate(
              context: context, page: const LoginScreen(), isRemoveUntil: true);
        } else {
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      });
    },
  ),
  RowOfAccountModel(
    title: "Delete Account",
    subTitle: "Permanently delete account and erase data",
    icon: Assets.svgsLogout,
    titleColor: const Color(0xFFDC2626),
    customLeading: Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFDC2626).withValues(alpha: 0.1),
      ),
      child: const Icon(Icons.delete_forever_rounded, size: 20, color: Color(0xFFDC2626)),
    ),
    onTap: (context) {
      _showDeleteAccountDialog(context);
    },
  ),
];
