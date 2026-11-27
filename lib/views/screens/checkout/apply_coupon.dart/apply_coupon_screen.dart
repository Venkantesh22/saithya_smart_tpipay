import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/coupon_controller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/checkout/checkout_screen/checkout_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/widget/custom_back_button.dart';

class ApplyCouponScreen extends StatefulWidget {
  const ApplyCouponScreen({super.key});

  @override
  State<ApplyCouponScreen> createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  bool isFocused = false;
  bool showBottomBack = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CouponController>().getAvailableCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("APPLY COUPON", style: Helper(context).textTheme.bodyLarge),
            GetBuilder<ProductController>(builder: (productController) {
              return CustomShimmer(
                isLoading: productController.isLoading,
                child: Text(
                  "Your Cart ${productController.cardModel?.totalPriceFormat ?? ""}",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: greyBillText,
                      ),
                ),
              );
            }),
          ],
        ),
        leading: const CustomBackButton(),
      ),
      bottomNavigationBar: AnimatedSlide(
        offset: showBottomBack ? const Offset(0, 0) : const Offset(0, 1),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: showBottomBack ? 1 : 0,
          child: showBottomBack
              ? Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 26),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: black.withValues(alpha: 0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: black.withValues(alpha: 0.4),
                        offset: const Offset(0, -2),
                        blurRadius: 4,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.inner,
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Coupon does not exist",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: black,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ProfileButton(
                          color: secondaryColor,
                          title: "Back",
                          onPressed: () => pop(context),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: GetBuilder<CouponController>(builder: (couponController) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Focus(
                  onFocusChange: (focus) {
                    setState(() {
                      isFocused = focus;
                    });
                  },
                  child: Padding(
                    padding: AppConstants.screenPadding,
                    child: TextFormField(
                      controller: couponController.couponCodeController,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        label: Text(
                          "Enter coupon code",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                color: isFocused ? secondaryColor : greyDark,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        suffix: GestureDetector(
                          onTap: () {
                            if (couponController
                                .couponCodeController.text.isNotEmpty) {
                              couponController
                                  .validateCouponController()
                                  .then((value) {
                                if (value.isSuccess) {
                                  navigate(
                                      context: context,
                                      page: const CheckoutScreen(
                                        showDialogOfDiscount: true,
                                      ));
                                } else {
                                  setState(() {
                                    showBottomBack = true;
                                  });
                                  showToast(
                                    message: value.message,
                                    typeCheck: value.isSuccess,
                                  );
                                }
                              });
                            }
                          },
                          child: Text(
                            "APPLY",
                            style:
                                Helper(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: isFocused ||
                                              couponController
                                                  .couponCodeController
                                                  .text
                                                  .isNotEmpty
                                          ? secondaryColor
                                          : greyDark,
                                    ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: secondaryColor, width: 1),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: red, width: 1),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: couponController.isLoadingCoupons
                      ? const Center(child: CircularProgressIndicator())
                      : couponController.availableCoupons.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_offer_outlined,
                                      size: 48,
                                      color: greyDark.withValues(alpha: 0.5)),
                                  const SizedBox(height: 12),
                                  Text(
                                    "No coupons available right now",
                                    style: Helper(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: greyDark),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount:
                                  couponController.availableCoupons.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final c =
                                    couponController.availableCoupons[index];
                                final code = c['code']?.toString() ?? "";
                                final formattedValue =
                                    c['formatted_value']?.toString() ??
                                        c['value']?.toString() ??
                                        "";
                                final desc =
                                    c['description']?.toString() ?? "";

                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: grey.withValues(alpha: 0.5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: black.withValues(alpha: 0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: secondaryColor
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                            Icons.confirmation_num_outlined,
                                            color: secondaryColor,
                                            size: 28),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  code,
                                                  style: Helper(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.8,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: green.withValues(
                                                        alpha: 0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    formattedValue,
                                                    style: const TextStyle(
                                                      color: green,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              desc,
                                              style: Helper(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: greyDark,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          couponController
                                              .validateCouponController(code)
                                              .then((value) {
                                            if (value.isSuccess) {
                                              navigate(
                                                context: context,
                                                page: const CheckoutScreen(
                                                  showDialogOfDiscount: true,
                                                ),
                                              );
                                            } else {
                                              showToast(
                                                message: value.message,
                                                typeCheck: value.isSuccess,
                                              );
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: secondaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: secondaryColor),
                                          ),
                                        ),
                                        child: const Text(
                                          "APPLY",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            // ✅ Full-screen loading overlay
            if (couponController.isLoading ||
                Get.find<ProductController>().isLoading)
              Container(
                color: black.withValues(alpha: 0.4),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}
