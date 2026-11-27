import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/account_screen/conponents/profile_row_title.dart';
import 'package:lekra/views/screens/dashboard/account_screen/conponents/row_of_account.dart';

class ProfileButton extends StatelessWidget {
  final bool isLoading;
  final String title;
  final Color color;
  final VoidCallback? onPressed; // nullable!
  const ProfileButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: white,
                ),
              )
            : Text(
                title,
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 16, color: white),
              ),
      ),
    );
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Account",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const UserProfileContainer(),
            const SizedBox(height: 35),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final rowOfAccountModel = rowOfAccountModelList[index];

                return RowOfAccount(
                  rowOfAccountModel: rowOfAccountModel,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(
                height: 26,
              ),
              itemCount: rowOfAccountModelList.length,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
