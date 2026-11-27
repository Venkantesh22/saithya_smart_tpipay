import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDescSection extends StatelessWidget {
  const ProductDescSection({
    super.key,
  });

  Future<void> _openUrl(String urlString, {String errorMsg = "Could not open link."}) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      Get.snackbar("Notice", errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      final product = productController.productModel;
      final String? desc = product?.description;
      final String? videoUrl = product?.videoUrl;
      final String? ytUrl = product?.youtubeUrl;
      final String? instaUrl = product?.instagramUrl;
      final String? fbUrl = product?.facebookUrl;
      final String? waUrl = product?.whatsappUrl;

      final bool hasSocial = (ytUrl != null && ytUrl.isNotEmpty) ||
          (instaUrl != null && instaUrl.isNotEmpty) ||
          (fbUrl != null && fbUrl.isNotEmpty) ||
          (waUrl != null && waUrl.isNotEmpty);

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Product Description & Info",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              capitalize(desc ?? "No description provided."),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),

            // Product Video Demonstration Button
            InkWell(
              onTap: () {
                if (videoUrl != null && videoUrl.isNotEmpty) {
                  _openUrl(videoUrl, errorMsg: "Could not open product video.");
                } else if (ytUrl != null && ytUrl.isNotEmpty) {
                  _openUrl(ytUrl, errorMsg: "Could not open YouTube video.");
                } else {
                  final query = product?.name ?? "Sathiya Smart Shopping Product Demo";
                  final String targetVideo =
                      "https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}";
                  _openUrl(targetVideo, errorMsg: "Could not search video on YouTube.");
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFF0000).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF0000),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (videoUrl != null && videoUrl.isNotEmpty)
                                ? "Watch Official Product Video Demo"
                                : "Watch Video Demonstration",
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                          ),
                          Text(
                            (videoUrl != null && videoUrl.isNotEmpty)
                                ? "Tap to stream high-definition product walkthrough & unboxing"
                                : "Tap to open product unboxing & demo video on YouTube",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.open_in_new_rounded,
                      color: Color(0xFFFF0000),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            // Social Media Handles & Support Channels
            if (hasSocial) ...[
              const SizedBox(height: 14),
              const Text(
                "Official Brand & Social Channels",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // YouTube
                  if (ytUrl != null && ytUrl.isNotEmpty)
                    _SocialPill(
                      label: "YouTube",
                      icon: Icons.smart_display_rounded,
                      color: const Color(0xFFFF0000),
                      bgColor: const Color(0xFFFFEBEB),
                      onTap: () => _openUrl(ytUrl, errorMsg: "Could not open YouTube."),
                    ),

                  // Instagram
                  if (instaUrl != null && instaUrl.isNotEmpty)
                    _SocialPill(
                      label: "Instagram",
                      icon: Icons.camera_alt_rounded,
                      color: const Color(0xFFE1306C),
                      bgColor: const Color(0xFFFDE8EF),
                      onTap: () => _openUrl(instaUrl, errorMsg: "Could not open Instagram."),
                    ),

                  // Facebook
                  if (fbUrl != null && fbUrl.isNotEmpty)
                    _SocialPill(
                      label: "Facebook",
                      icon: Icons.facebook_rounded,
                      color: const Color(0xFF1877F2),
                      bgColor: const Color(0xFFE7F3FF),
                      onTap: () => _openUrl(fbUrl, errorMsg: "Could not open Facebook."),
                    ),

                  // WhatsApp
                  if (waUrl != null && waUrl.isNotEmpty)
                    _SocialPill(
                      label: "WhatsApp",
                      icon: Icons.chat_rounded,
                      color: const Color(0xFF25D366),
                      bgColor: const Color(0xFFE8F9EE),
                      onTap: () => _openUrl(waUrl, errorMsg: "Could not open WhatsApp."),
                    ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _SocialPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _SocialPill({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
