import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:url_launcher/url_launcher.dart';

class GrievanceOfficerScreen extends StatefulWidget {
  const GrievanceOfficerScreen({super.key});

  @override
  State<GrievanceOfficerScreen> createState() => _GrievanceOfficerScreenState();
}

class _GrievanceOfficerScreenState extends State<GrievanceOfficerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchGrievanceOfficer();
    });
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching $urlString: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar2(title: "Grievance Officer"),
      body: GetBuilder<BasicController>(builder: (basicController) {
        if (basicController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final officer = basicController.grievanceOfficerInfo ?? {};
        final officerName = officer['officer_name'] ?? "Mr. Rajesh Kumar";
        final designation = officer['designation'] ??
            "Grievance Redressal & Data Protection Officer";
        final email = officer['email'] ?? "grievance@sathyasmart.com";
        final phone = officer['phone'] ?? "+91 9876543210";
        final hours = officer['working_hours'] ??
            "Monday to Saturday, 10:00 AM – 6:00 PM IST";
        final address = officer['address'] ?? "Sathiya Smart Corporate Office, India";

        final contentHtml = basicController.grievanceOfficerHtml.trim().isNotEmpty
            ? basicController.grievanceOfficerHtml
            : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Officer Contact Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      color: black.withValues(alpha: 0.03),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 26,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                officerName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                designation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    const SizedBox(height: 16),

                    // Statutory Notice Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.gavel_rounded,
                              size: 18, color: Color(0xFFB45309)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Statutory Contact as mandated under Rule 3(2) of IT Rules, 2021 & DPDP Act, 2023",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF92400E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Email Row
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.email_outlined,
                            color: Color(0xFF4F46E5), size: 18),
                      ),
                      title: const Text("Email Address",
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      subtitle: Text(email,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A))),
                      trailing: IconButton(
                        icon: const Icon(Icons.send_rounded,
                            color: Color(0xFF4F46E5), size: 20),
                        onPressed: () => _launchUrl("mailto:$email"),
                      ),
                    ),
                    const Divider(color: Color(0xFFF8FAFC)),

                    // Phone Row
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.phone_outlined,
                            color: Color(0xFF16A34A), size: 18),
                      ),
                      title: const Text("Helpline Phone",
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      subtitle: Text(phone,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A))),
                      trailing: IconButton(
                        icon: const Icon(Icons.call_rounded,
                            color: Color(0xFF16A34A), size: 20),
                        onPressed: () => _launchUrl("tel:$phone"),
                      ),
                    ),
                    const Divider(color: Color(0xFFF8FAFC)),

                    // Working Hours Row
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.access_time_rounded,
                            color: Color(0xFFD97706), size: 18),
                      ),
                      title: const Text("Working Hours",
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      subtitle: Text(hours,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A))),
                    ),
                    const Divider(color: Color(0xFFF8FAFC)),

                    // Address Row
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.location_on_outlined,
                            color: Color(0xFF475569), size: 18),
                      ),
                      title: const Text("Postal Address",
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      subtitle: Text(address,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A))),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Redressal Timelines Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Statutory Resolution Timelines",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Acknowledgment",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF4F46E5),
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("Within 48 Hours",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Final Disposal",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF16A34A),
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("Within 15 Days",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (contentHtml != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: HtmlWidget(
                    contentHtml,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      height: 1.6,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}
