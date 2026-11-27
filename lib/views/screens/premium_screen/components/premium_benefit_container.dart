import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class PremiumBenefitContainer extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final String? badgeText;
  final Color? accentColor;

  const PremiumBenefitContainer({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    this.badgeText,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = accentColor ?? primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 12,
            color: black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: effectiveAccent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomImage(
              path: image,
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Helper(context).textTheme.titleMedium?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                      ),
                    ),
                    if (badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Text(
                          badgeText!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        height: 1.5,
                        color: const Color(0xFF64748B),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
