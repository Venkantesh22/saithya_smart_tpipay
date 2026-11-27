import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/lanch_helper.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/support/widget/help_supper_call_email_widget.dart';

class HelpMedSection extends StatefulWidget {
  const HelpMedSection({super.key});

  @override
  State<HelpMedSection> createState() => _HelpMedSectionState();
}

class _HelpMedSectionState extends State<HelpMedSection> {
  int? expandedFaqIndex;

  final List<Map<String, String>> faqs = [
    {
      "q": "How do I track my orders and deliveries?",
      "a": "You can track your active orders by navigating to the 'Orders' tab from the bottom navigation bar. You will receive real-time status updates from placement to doorstep dispatch."
    },
    {
      "q": "How does mobile recharge & cashback work?",
      "a": "Select 'Recharge' from the dashboard, choose your operator and circle, and select your preferred plan. Instant cashback is automatically credited to your wallet balance upon transaction completion."
    },
    {
      "q": "What are the benefits of VIP Membership?",
      "a": "VIP Members enjoy guaranteed free deliveries, instant gift wallet credits, extra recharge cashback, and top-priority 24/7 dedicated customer assistance."
    },
    {
      "q": "How can I update my Wallet PIN or password?",
      "a": "Go to Account > Update Wallet Password or Update Password. Complete the OTP verification sent to your registered mobile number to set a new secure PIN."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      final phone = basicController.supportModel?.mobile?.isNotEmpty == true
          ? basicController.supportModel!.mobile!
          : "+91 9876543210";
      final whatsapp = basicController.supportModel?.whatsapp?.isNotEmpty == true
          ? basicController.supportModel!.whatsapp!
          : "+91 9876543210";
      final email = basicController.supportModel?.email?.isNotEmpty == true
          ? basicController.supportModel!.email!
          : "support@sathyasmart.com";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),

          // Section Title
          const Row(
            children: [
              Icon(Icons.contact_support_outlined, size: 18, color: Color(0xFF0F172A)),
              SizedBox(width: 8),
              Text(
                "Direct Channels",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Choose your preferred way to connect with us",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // 1. Phone Helpline Card
          HelpContactCard(
            title: "CUSTOMER HELPLINE",
            value: phone,
            note: "Voice call with dedicated support agent",
            actionText: "Call Helpline Now",
            icon: Icons.phone_in_talk_rounded,
            accentColor: const Color(0xFF2563EB),
            bgColor: const Color(0xFFEFF6FF),
            onAction: () {
              LaunchHelper.callUs(number: phone);
            },
          ),

          const SizedBox(height: 12),

          // 2. WhatsApp Live Chat Card
          HelpContactCard(
            title: "WHATSAPP LIVE CHAT",
            value: whatsapp,
            note: "Fast messaging & query resolution",
            actionText: "Chat on WhatsApp",
            icon: Icons.chat_rounded,
            accentColor: const Color(0xFF059669),
            bgColor: const Color(0xFFECFDF5),
            onAction: () {
              LaunchHelper.launchWhatsApp(
                phone: whatsapp,
                message: "Hello Sathiya Smart Support, I need assistance with my account.",
              );
            },
          ),

          const SizedBox(height: 12),

          // 3. Email Support Card
          HelpContactCard(
            title: "EMAIL HELPDESK",
            value: email,
            note: "Official inquiries, billing & escalations",
            actionText: "Send Support Email",
            icon: Icons.mail_rounded,
            accentColor: const Color(0xFF7C3AED),
            bgColor: const Color(0xFFF5F3FF),
            onAction: () {
              LaunchHelper.emailUs(email: email);
            },
          ),

          const SizedBox(height: 12),

          // 4. Live Meeting Schedule (Google Meet / Zoom)
          HelpContactCard(
            title: "LIVE VIDEO MEETING (GMEET / ZOOM)",
            value: "Schedule VIP Call",
            note: "1-on-1 VIP member onboarding & support via Google Meet / Zoom",
            actionText: "Schedule Video Meeting",
            icon: Icons.video_camera_front_rounded,
            accentColor: const Color(0xFFEA580C),
            bgColor: const Color(0xFFFFF7ED),
            onAction: () {
              LaunchHelper.launchWhatsApp(
                phone: whatsapp,
                message: "Hello Support, I would like to schedule a 1-on-1 Google Meet / Zoom session for account guidance.",
              );
            },
          ),

          const SizedBox(height: 28),

          // FAQ Section Header
          const Row(
            children: [
              Icon(Icons.quiz_outlined, size: 18, color: Color(0xFF0F172A)),
              SizedBox(width: 8),
              Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Quick answers to common questions",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // FAQ List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: faqs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final isExpanded = expandedFaqIndex == index;
              final faq = faqs[index];

              return Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isExpanded ? primaryColor.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                      color: black.withValues(alpha: 0.02),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    title: Text(
                      faq["q"]!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isExpanded ? primaryColor : const Color(0xFF0F172A),
                      ),
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: isExpanded ? primaryColor : const Color(0xFF64748B),
                    ),
                    onExpansionChanged: (val) {
                      setState(() {
                        expandedFaqIndex = val ? index : null;
                      });
                    },
                    children: [
                      Text(
                        faq["a"]!,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Security & Trust Note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF64748B)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "All support communication is encrypted & logged for customer safety.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}
