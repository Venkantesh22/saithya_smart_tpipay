import 'package:flutter/material.dart';
import 'package:lekra/data/models/scratch_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/custom_image.dart';

class ScratchCardWidget extends StatelessWidget {
  final ScratchCardModel scratchCardModel;

  const ScratchCardWidget({
    super.key,
    required this.scratchCardModel,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent;

    if (scratchCardModel.isScratch) {
      final isCoins = !scratchCardModel.isDiscount;

      cardContent = Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // After coins/rewards credited to wallet, card color is black as specified
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1E24), Color(0xFF09090B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFF3F3F46), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      scratchCardModel.isDiscount
                          ? "🎉 Cashback Voucher Won"
                          : "🪙 Coins Credited to Wallet",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFBBF24),
                            fontSize: 11,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scratchCardModel.isDiscount
                          ? "${scratchCardModel.rewardPoints} OFF"
                          : "${scratchCardModel.rewardPoints} Coins",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isCoins
                            ? const Color(0xFF14532D)
                            : const Color(0xFF7C2D12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isCoins
                            ? "Never Expires"
                            : "Expires in 1 Month",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isCoins
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFFFDBA74),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white24, width: 0.8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 10),
                      SizedBox(width: 3),
                      Text(
                        "CLAIMED",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      cardContent = Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const CustomImage(
          path: Assets.imagesScratch,
          fit: BoxFit.cover,
        ),
      );
    }

    if (scratchCardModel.isExpiry) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.3,
          0.59,
          0.11,
          0,
          0,
          0.3,
          0.59,
          0.11,
          0,
          0,
          0.3,
          0.59,
          0.11,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
