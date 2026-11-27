import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/views/screens/dashboard/profile_edit/components/profile_edit_from_section.dart';
import 'package:lekra/views/screens/dashboard/profile_edit/components/profile_edit_top_section.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Get.find<AuthController>();
      authController.fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController) {
        if (authController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileTopSection(),
              ProfileEditFormSection(),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      }),
    );
  }
}
