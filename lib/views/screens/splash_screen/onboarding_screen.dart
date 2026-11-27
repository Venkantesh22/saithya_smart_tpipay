import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/main.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "icon": Icons.account_balance_wallet_rounded,
      "badge": "SMART RECHARGES & BILLS",
      "title": "Fast, Secure & Rewarding\nMobile & Utility Payments",
      "description":
          "Recharge prepaid mobiles, DTH & pay electricity, water and gas bills in seconds with zero transaction fees and instant cashback.",
      "features": [
        "Instant Recharges",
        "100% Safe Payments",
        "Guaranteed Cashback"
      ],
      "gradient": [Color(0xFF4F46E5), Color(0xFF7C3AED)],
    },
    {
      "icon": Icons.shopping_bag_rounded,
      "badge": "SMART COMMERCE",
      "title": "Shop Thousands of Products\nWith Guaranteed Rewards",
      "description":
          "Browse top fashion, electronics, and daily essentials. Unlock scratch cards and earn redeemable reward coins on every single purchase.",
      "features": [
        "10,000+ Products",
        "Free VIP Delivery",
        "Direct Factory Prices"
      ],
      "gradient": [Color(0xFF0D9488), Color(0xFF0284C7)],
    },
    {
      "icon": Icons.stars_rounded,
      "badge": "PRIME MEMBERSHIP & INCOME",
      "title": "Prime VIP Benefits &\n15-Level Referral Earnings",
      "description":
          "Enjoy unlimited free delivery subsidies, daily fortune spin wheels, and earn multi-tier residual income from your growing network.",
      "features": [
        "Exclusive VIP Status",
        "15-Level Downline Bonus",
        "Daily Fortune Spin"
      ],
      "gradient": [Color(0xFFD97706), Color(0xFFDC2626)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_currentPage < _onboardingData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _completeOnboarding() {
    _autoSlideTimer?.cancel();
    final basicController = Get.find<BasicController>();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      basicController.setIsDemoSave(true);
    } else if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      basicController.setIsDemoSave(true);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      basicController.setIsDemoSave(true);
    }
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Logo & Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Assets.imagesOnlyLogo,
                        height: 38,
                        width: 38,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.bolt_rounded,
                          color: primaryColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppConstants.appName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _completeOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3 Auto-sliding Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  final List<Color> colors = data["gradient"];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Hero Visual Card
                        Container(
                          width: double.infinity,
                          height: size.height * 0.35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: colors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: colors[0].withOpacity(0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                top: -20,
                                right: -20,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -30,
                                left: -30,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(22),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      data["icon"] as IconData,
                                      size: 58,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      data["badge"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Title
                        Text(
                          data["title"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            data["description"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Highlights Row
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: ((data["features"] as List<String>?) ?? [])
                              .map((feat) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (colors[0] as Color).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:
                                        (colors[0] as Color).withOpacity(0.2)),
                              ),
                              child: Text(
                                feat,
                                style: TextStyle(
                                  color: colors[0],
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 26 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    shadowColor: primaryColor.withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
