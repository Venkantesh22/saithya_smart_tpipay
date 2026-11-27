import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class ColumnOfInfo extends StatelessWidget {
  final String? title;
  final String? text;
  const ColumnOfInfo({super.key, this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: Helper(context).textTheme.headlineSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: greyText2,
              ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: blueDark.withValues(alpha: 0.1)),
          child: Row(
            children: [
              Text(
                text ?? "",
                style: Helper(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: blackText,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
