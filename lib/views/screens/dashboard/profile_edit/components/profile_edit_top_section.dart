import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/image_picker_sheet.dart';

class EditProfileTopSection extends StatelessWidget {
  const EditProfileTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [primaryColor.withValues(alpha: 0.63), white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => pop(context),
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, top: 10),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        color: black.withValues(alpha: 0.29),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: white, size: 18),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                border: Border(
                  top: BorderSide(
                      color: Color(
                        0xFF898A8D,
                      ),
                      width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 22,
            child: _buildProfileImage(authController, context),
          ),
        ],
      );
    });
  }

  Widget _buildProfileImage(
      AuthController authController, BuildContext context) {
    bool hasLocalImage = authController.profileImage != null;

    return InkWell(
      onTap: () async {
        final file = await getImageBottomSheet(context);
        if (file != null) {
          authController.updateImages(file);
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: white, width: 4),
              boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: hasLocalImage
                  ? Image.file(
                      authController.profileImage!,
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    )
                  : CustomImage(
                      color: white,
                      isProfile: true,
                      path: authController.userModel?.image ?? "",
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                      radius: 100,
                    ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 8,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.edit,
                color: white,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
