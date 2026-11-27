import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';

import 'package:lekra/controllers/reward_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/order_screem/screen/order_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';

class SpinWheelPage extends StatefulWidget {
  const SpinWheelPage({super.key});

  @override
  State<SpinWheelPage> createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage> {
  final _controller = StreamController<int>();

  int? _lastFocusedIndex;
  int? _displayedWinnerIndex;
  int _resultVersion = 0;

  bool _hasSpun = false;

  /// Ensure we auto-spin exactly one time on first render.
  bool _autoSpinScheduled = false;

  // Optional: per-slice colors
  static const _sliceColors = <Color>[
    Color(0xFF0D80F2),
    Color(0xFF8DC3F9),
    Color(0xFF0D80F2),
    Color(0xFF8DC3F9),
    Color(0xFF0D80F2),
    Color(0xFF0C25E6),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RewardsController>().fetchSpinWheel();
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  // Start a spin with a random index (Fortune.randomInt is from the package)
  void _startRandomSpin(int length) {
    if (length <= 1) {
      _controller.add(0);
      return;
    }
    final idx = Fortune.randomInt(0, length); // [min, max)
    _controller.add(idx);
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.orange;
    const size = 354.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        navigate(
            context: context, page: const OrderScreen(), isRemoveUntil: true);
      },
      child: Scaffold(
        appBar: CustomAppbarBackButton(),
        body: GetBuilder<RewardsController>(
          builder: (c) {
            final raw = c.spinWheelList;

            // Loading
            if (raw.isEmpty && c.isLoading == true) {
              return const Center(child: CircularProgressIndicator());
            }

            // Empty
            if (raw.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        'No spin items available right now.',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: c.fetchSpinWheel,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // FortuneWheel requires > 1 item. If exactly 1, duplicate it.
            final data = raw.length == 1 ? [raw.first, raw.first] : raw;

            // We do NOT allow manual spins; we auto-spin once, then disable forever.
            final canSpin = !_hasSpun && data.length > 1;

            // Auto-spin once when data is ready (only once)
            if (canSpin && !_autoSpinScheduled) {
              _autoSpinScheduled = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _startRandomSpin(data.length);
              });
            }

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: size + 16,
                      height: size + 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 6),
                      ),
                      child: SizedBox(
                        width: size,
                        height: size,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            FortuneWheel(
                              selected: _controller.stream,
                              indicators: <FortuneIndicator>[
                                FortuneIndicator(
                                  alignment: Alignment.topCenter,
                                  child: Transform.translate(
                                    offset: const Offset(0, -30),
                                    child: TriangleIndicator(
                                      color: secondaryColor,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ],
                              onFocusItemChanged: (i) {
                                if (_lastFocusedIndex == i) return;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() => _lastFocusedIndex = i);
                                });
                              },
                              onAnimationEnd: () {
                                final rewardsController =
                                    Get.find<RewardsController>();
                                final idx = _lastFocusedIndex;
                                if (idx == null) return;

                                // Lock any further spins
                                setState(() {
                                  _hasSpun = true;
                                  _displayedWinnerIndex = idx;
                                  _resultVersion++;
                                });

                                // Save winner in controller
                                rewardsController
                                    .setWinSpinWheelModel(data[idx]);

                                // Optional: persist spin result, show toast
                                rewardsController
                                    .postCreateScratchCard()
                                    .then((value) {
                                  if (value.isSuccess) {
                                    showToast(
                                        message: value.message,
                                        typeCheck: value.isSuccess);
                                    Get.find<DashBoardController>().dashPage =
                                        2;
                                    navigate(
                                        isRemoveUntil: true,
                                        context: context,
                                        page: const DashboardScreen());
                                  } else {
                                    showToast(
                                        message: value.message,
                                        typeCheck: value.isSuccess);
                                  }
                                });

                                // Navigate to Order screen with the prize
                                final prize =
                                    rewardsController.winSpinWheelModel;
                                if (prize != null) {
                                  // Example 1: GetX direct
                                  // Get.off(() => OrderScreen(prize: prize));

                                  // Example 2: Named route with arguments
                                  // Get.offNamed('/order', arguments: {'prize': prize});

                                  // Example 3: Your own helper
                                  // navigate(context: context, page: OrderScreen(prize: prize));
                                }
                              },
                              items: List.generate(data.length, (i) {
                                final item = data[i];
                                return FortuneItem(
                                  child: Center(
                                    child: Text(
                                      // a few leading spaces to offset from pointer
                                      "            ${item.offerName ?? ''}",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  style: FortuneItemStyle(
                                    color:
                                        _sliceColors[i % _sliceColors.length],
                                    borderWidth: 2,
                                    borderColor: Colors.white.withOpacity(0.6),
                                  ),
                                );
                              }),
                            ),

                            // Center button (disabled; we auto-spin)
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 62,
                                width: 62,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      spreadRadius: 0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "SPIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Winner text (may flash briefly before navigation)
                    GetBuilder<RewardsController>(
                      id: 'winner_text',
                      builder: (rc) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: (_displayedWinnerIndex == null ||
                                rc.winSpinWheelModel == null)
                            ? const SizedBox(key: ValueKey('empty'), height: 24)
                            : Text(
                                '🎉 You won: ${rc.winSpinWheelModel?.offerName ?? ""}',
                                key: ValueKey('res-$_resultVersion'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 55),

                    GetBuilder<RewardsController>(builder: (rewardsController) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: rewardsController.winSpinWheelModel != null
                            ? Container(
                                key: ValueKey(rewardsController
                                    .winSpinWheelModel?.offerName),
                                width: 263,
                                height: 69,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xEDFF7700),
                                      Color(0x8F0D80F2),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "🎉 Congratulations!",
                                      style: Helper(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: white,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'You won: ${rewardsController.winSpinWheelModel?.offerName}',
                                      style: Helper(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: white,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
