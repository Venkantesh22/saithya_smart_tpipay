import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/data/models/body/address_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/address/screen/add_address_screen.dart';
import 'package:lekra/views/screens/checkout/checkout_screen/components/check_box_of_order_user_reward.dart';
import 'package:lekra/views/screens/checkout/checkout_screen/components/textbox_title.dart';

class BillingFormSection extends StatefulWidget {
  const BillingFormSection({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  State<BillingFormSection> createState() => _BillingFormSectionState();
}

class _BillingFormSectionState extends State<BillingFormSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderController = Get.find<OrderController>();
      final authController = Get.find<AuthController>();
      orderController.billingName.text =
          authController.userModel?.fullName ?? "";
      orderController.billingEmail.text = authController.userModel?.email ?? "";
      orderController.billingNumber.text =
          authController.userModel?.mobile ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (checkoutController) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: black.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0)
            ]),
        child: GetBuilder<BasicController>(builder: (basicController) {
          if (basicController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery & Billing Details',
                  style: Helper(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              Text('Select Delivery Address',
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 13)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: greyBorder)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AddressModel?>(
                    isExpanded: true,
                    value: basicController.selectAddress,
                    items: basicController.addressList.isEmpty
                        ? []
                        : basicController.addressList.map((addr) {
                            return DropdownMenuItem<AddressModel?>(
                              value: addr,
                              child: CustomShimmer(
                                isLoading: basicController.isLoading,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          addr.fullAddress,
                                          overflow: TextOverflow.visible,
                                          style: Helper(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 14,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      basicController.updateSelectAddress(v);
                    },
                    icon: const Icon(
                      Icons.expand_more,
                      color: black,
                    ),
                    dropdownColor: greyBorder,
                  ),
                ),
              ),
              Form(
                key: widget._formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        foregroundColor: primaryColor,
                        textStyle: Helper(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        navigate(
                            context: context, page: const AddAddressScreen());
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add New Address'),
                    ),
                    const SizedBox(height: 10),
                    CustomTextboxWithTitle(
                      title: "Billing Name",
                      controller: checkoutController.billingName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextboxWithTitle(
                      title: "Billing Email",
                      controller: checkoutController.billingEmail,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Billing Mobile Number",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: checkoutController.billingNumber,
                      decoration: CustomDecoration.inputDecoration(
                        hint: "Enter your Billing Number",
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: grey,
                                ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your number";
                        }
                        if (value.length != 10) {
                          return "Please number should be 10 digit";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CheckBoxOfOrderUserReward()
            ],
          );
        }),
      );
    });
  }
}
