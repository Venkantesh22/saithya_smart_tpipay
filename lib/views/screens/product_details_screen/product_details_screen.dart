import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/lanch_helper.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/product_details_screen/components/key_featured_section.dart';
import 'package:lekra/views/screens/product_details_screen/components/image_section.dart';
import 'package:lekra/views/screens/product_details_screen/components/product_descr_section.dart';
import 'package:lekra/views/screens/product_details_screen/components/product_title_section.dart';
import 'package:lekra/views/screens/widget/add_to_card_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductController>().fetchProduct(productId: widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.arrow_back_ios_new,
          color: black,
          size: 20,
        ),
        title: Text(
          "Product Detail",
          style: Helper(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: blackText,
              ),
        ),
        actions: [
          // SvgPicture.asset(
          //   Assets.svgsWishList,
          //   width: 20,
          //   height: 19,
          //   colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          // ),
          // sizedBoxWidth(width: 24),
          GetBuilder<ProductController>(builder: (productController) {
            return GestureDetector(
              onTap: () {
                LaunchHelper.shareToAllApps(
                    title: productController.productModel?.name ?? '',
                    message: "Check out this product on Saithya Smart 👇\n\n ",
                    link:
                        '${AppConstants.baseUrl}${AppConstants.getProductDetails}/${widget.productId}');
              },
              child: SvgPicture.asset(
                Assets.svgsShare,
                width: 20,
                height: 19,
                colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
            );
          }),
          sizedBoxWidth(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProductImageSection(),
              const ProdTitleSection(),
              const SizedBox(
                height: 12,
              ),
              GetBuilder<ProductController>(builder: (productController) {
                return AddToCardButton(
                  product: productController.productModel ?? ProductModel(),
                );
              }),
              const SizedBox(height: 32),
              const KeyFeaturesSection(),
              const SizedBox(height: 18),
              const ProductDescSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
