import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lekra/data/models/scratch_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class RewardDetailsScreen extends StatefulWidget {
  final ScratchCardModel scratchCardModel;
  const RewardDetailsScreen({
    super.key,
    required this.scratchCardModel,
  });

  @override
  State<RewardDetailsScreen> createState() => _RewardDetailsScreenState();
}

class _RewardDetailsScreenState extends State<RewardDetailsScreen> {
  TextEditingController codeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scratchCardModel.isDiscount) {
        codeController.text = widget.scratchCardModel.code ?? "";
      }
    });
  }

  void _copyReferralCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: ""),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.scratchCardModel.isDiscount
                ? const CustomImage(
                    path: Assets.imagesYourWonDiscount,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const CustomImage(
                    path: Assets.imagesYourWonPoint,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.scratchCardModel.isDiscount
                        ? "${widget.scratchCardModel.rewardPoints} Discount"
                        : "${widget.scratchCardModel.rewardPoints} Coins Credited",
                    style: Helper(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.scratchCardModel.isDiscount)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        readOnly: true,
                        onTap: () => _copyReferralCode(
                            context, widget.scratchCardModel.code ?? ""),
                        controller: codeController,
                        style: Helper(context).textTheme.bodyMedium,
                        decoration: CustomDecoration.inputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          borderColor: greyDark,
                          suffix: const Icon(Icons.copy),
                          hintStyle: Helper(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: greyDark),
                        ),
                      ),
                    ),
                  Text(
                    "Expiry Date",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: secondaryColor),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    DateFormatters().mdy.format(
                        widget.scratchCardModel.expiryDate ?? DateTime.now()),
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   "Details",
                  //   style: Helper(context).textTheme.bodyMedium?.copyWith(
                  //       fontWeight: FontWeight.bold, color: secondaryColor),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
