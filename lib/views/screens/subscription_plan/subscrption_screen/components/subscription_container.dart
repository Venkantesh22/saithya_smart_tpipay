import 'package:flutter/material.dart';
import 'package:lekra/data/models/subscription_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';

class SubscriptionContainer extends StatelessWidget {
  const SubscriptionContainer({
    super.key,
    required this.subscription,
    required this.onPressed,
  });

  final SubscriptionModel? subscription;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = subscription?.hasDiscount ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            color: black.withValues(alpha: 0.03),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subscription?.name ?? "",
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: const Color(0xFF0F172A),
                ),
          ),
          const SizedBox(
            height: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasDiscount)
                Row(
                  children: [
                    Text(
                      subscription?.priceFormat ?? "",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: grey,
                            decorationThickness: 2,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "SAVE ${subscription?.discountAmountFormat ?? ''}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
              RichText(
                text: TextSpan(
                  text: hasDiscount
                      ? subscription?.discountPriceFormat
                      : (subscription?.priceFormat ?? ""),
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        color: const Color(0xFF0F172A),
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " / ",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: const Color(0xFF64748B)),
                    ),
                    TextSpan(
                      text: subscription?.validityLabel ?? "365 Days (1 Year)",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF64748B)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.verified_outlined, size: 12, color: Color(0xFF15803D)),
                  const SizedBox(width: 4),
                  Text(
                    "Price inclusive of 18% GST (GST Invoice provided)",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
              if ((subscription?.packageValue != null && subscription!.packageValue! > 0) ||
                  (subscription?.scratchCardValue != null && subscription!.scratchCardValue! > 0) ||
                  (subscription?.hasFreeDelivery == true)) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (subscription?.packageValue != null && subscription!.packageValue! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Text(
                          "Value: ₹${subscription!.packageValue!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                    if (subscription?.scratchCardValue != null && subscription!.scratchCardValue! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Text(
                          "🎁 Scratch Card: ₹${subscription!.scratchCardValue!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                    if (subscription?.hasFreeDelivery == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: const Text(
                          "🚚 Free Delivery",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          ProfileButton(
              title: "View Details", onPressed: onPressed, color: primaryColor)
        ],
      ),
    );
  }
}
