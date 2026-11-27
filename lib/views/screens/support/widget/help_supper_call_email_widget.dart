import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class HelpContactCard extends StatelessWidget {
  final String title;
  final String value;
  final String note;
  final String actionText;
  final IconData icon;
  final Color accentColor;
  final Color bgColor;
  final VoidCallback onAction;

  const HelpContactCard({
    super.key,
    required this.title,
    required this.value,
    required this.note,
    required this.actionText,
    required this.icon,
    required this.accentColor,
    required this.bgColor,
    required this.onAction,
  });

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    showToast(message: "Copied: $value", toastType: ToastType.info);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: accentColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      note,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: "Copy",
                onPressed: () => _copy(context),
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onAction,
              icon: Icon(icon, size: 16),
              label: Text(
                actionText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
