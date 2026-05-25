import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class HelpTopSection extends StatelessWidget {
  const HelpTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How can we help you?",
          overflow: TextOverflow.clip,
          style: Helper(context).textTheme.displaySmall?.copyWith(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: blackText,
                // letterSpacing: -0.9,
              ),
        ),
        sizedBoxHeight(height: 8),
        Text(
          "Our concierge team is available 24/7 to ensure your experience remains seamless.",
          overflow: TextOverflow.clip,
          style: Helper(context).textTheme.headlineSmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: greyText2,
              ),
        ),
        sizedBoxHeight(height: 40),
        // HelpNumberAndEmailWidget()
      ],
    );
  }
}
