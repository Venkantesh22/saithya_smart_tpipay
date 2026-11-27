import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/recharge_state_area_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_dropdown.dart';
import 'package:lekra/views/base/custom_image.dart';

class MobileRechargeNoMidSection extends StatefulWidget {
  const MobileRechargeNoMidSection({
    super.key,
  });

  @override
  State<MobileRechargeNoMidSection> createState() =>
      _MobileRechargeNoMidSectionState();
}

class _MobileRechargeNoMidSectionState
    extends State<MobileRechargeNoMidSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return Column(
        children: [
          SizedBox(height: 31.5),
          CustomDropDownList(
            bgColor: Color(0xFFDCE9FF),
            borderColor: Color(0xFFDCE9FF),
            hintText: "Select Telecom Provider",
            headingWidget: Text(
              "SELECT OPERATOR",
              style: Helper(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: greyText2,
                    letterSpacing: 1,
                  ),
            ),
            items: rechargeController.networkServiceModelList
                .map((e) => e.networkName)
                .toList(),
            itemWidget: rechargeController.networkServiceModelList
                .map((e) => Row(
                      children: [
                        CustomImage(
                          path: e.logo,
                          fit: BoxFit.cover,
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 12),
                        Text(e.networkName),
                      ],
                    ))
                .toList(),
            value: rechargeController.selectNetworkOperate?.networkName,
            onChanged: (value) {
              rechargeController.selectNetworkOperate =
                  rechargeController.networkServiceModelList.firstWhere(
                (element) => element.networkName == value,
              );

              rechargeController.update();
            },
            validator: (value) {
              if (value == null) {
                return "Select a service provider";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(height: 31.5),
          CustomDropDownList(
            bgColor: Color(0xFFDCE9FF),
            borderColor: Color(0xFFDCE9FF),
            hintText: "Select Telecom Provider",
            preFixWidget: Icon(
              Icons.location_on_outlined,
              color: blueDark,
            ),
            headingWidget: Text(
              "SELECT STATUS OR SERVICE TYPE",
              style: Helper(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: greyText2,
                    letterSpacing: 1,
                  ),
            ),
            items: rechargeStateAreaModelList.map((e) => e.areaName).toList(),
            value: rechargeController.selectRechargeStateAreaModel?.areaName,
            onChanged: (value) {
              rechargeController.selectRechargeStateAreaModel =
                  rechargeStateAreaModelList.firstWhere(
                (element) => element.areaName == value,
              );

              rechargeController.update();
            },
            validator: (value) {
              if (value == null) {
                return "Please a your state";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
