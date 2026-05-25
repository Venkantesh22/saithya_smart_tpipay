import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/support/widget/help_supper_call_email_widget.dart';

class HelpMedSection extends StatelessWidget {
  const HelpMedSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      final _helpList = helpNumberAndEmailWidgetModelList(basicController);
      return Column(
        children: [
          sizedBoxHeight(height: 40),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final _helpListModel = _helpList[index];
                return CustomShimmer(
                  isLoading: basicController.isLoading,
                  child: HelpNumberAndEmailWidget(
                      helpNumberAndEmailWidgetModel: _helpListModel),
                );
              },
              separatorBuilder: (_, __) => sizedBoxHeight(height: 24),
              itemCount: _helpList.length)
        ],
      );
    });
  }
}
