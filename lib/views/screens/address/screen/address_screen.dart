import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/data/models/body/address_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_refresh_indicator.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/address/screen/add_address_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresh(
      onRefresh: () async {
        Get.find<BasicController>().fetchAddress();
      },
      child: Scaffold(
        appBar: CustomAppBar2(title: "Address"),
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
              color: secondaryColor, borderRadius: BorderRadius.circular(12)),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
              foregroundColor: primaryColor,
              textStyle: Helper(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              navigate(context: context, page: const AddAddressScreen());
            },
            icon: const Icon(
              Icons.add,
              size: 18,
              color: white,
            ),
            label: Text(
              'Add New Address',
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14, fontWeight: FontWeight.bold, color: white),
            ),
          ),
        ),
        body: GetBuilder<BasicController>(builder: (basicController) {
          if (basicController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (basicController.addressList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_off_outlined,
                        size: 56,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Saved Addresses Yet",
                      style: Helper(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Save your delivery address for quick checkout when shopping.",
                      textAlign: TextAlign.center,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            color: greyAccountText,
                            fontSize: 13,
                          ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        navigate(
                            context: context, page: const AddAddressScreen());
                      },
                      icon: const Icon(Icons.add, color: white),
                      label: Text(
                        "Add Address Now",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: AppConstants.screenPadding,
            itemBuilder: (context, index) {
              final address = basicController.isLoading
                  ? AddressModel()
                  : basicController.addressList[index];
              index = index + 1;
              return CustomShimmer(
                  isLoading: basicController.isLoading,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              spreadRadius: 0,
                              offset: const Offset(0, 6))
                        ]),
                    child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.home,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Home $index",
                                  style: Helper(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              overflow: TextOverflow.clip,
                              address.fullAddress,
                              style: Helper(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: black),
                            ),
                          ],
                        ),
                        trailing: basicController.addressDeleteLoading
                            ? const CircularProgressIndicator()
                            : IconButton(
                                onPressed: () {
                                  {
                                    Get.find<BasicController>()
                                        .deleteAddress(addressId: address.id)
                                        .then((value) {
                                      if (value.isSuccess) {
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
                                icon: const Icon(
                                  Icons.delete,
                                  color: red,
                                ))),
                  ));
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: basicController.isLoading
                ? 4
                : basicController.addressList.length,
          );
        }),
      ),
    );
  }
}
