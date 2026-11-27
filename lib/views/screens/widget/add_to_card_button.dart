import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/card_screen/card_screen.dart';

class AddToCardButton extends StatelessWidget {
  final ProductModel product;

  const AddToCardButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      final bool isAdd = productController.cardModel?.products
              ?.any((p) => p.id == product.id) ??
          false;
      return GestureDetector(
        onTap: () {
          if (productController.isLoading) {
            showToast(
                message: "Please wait product adding to card",
                toastType: ToastType.info);
            return;
          }

          if (isAdd) {
            navigate(context: context, page: const CardScreen());
          } else {
            productController.postAddToCard(product: product).then((value) {
              if (value.isSuccess) {
                showToast(message: value.message, typeCheck: value.isSuccess);
              } else {
                showToast(message: value.message, typeCheck: value.isSuccess);
              }
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
              color: isAdd ? secondaryColor : primaryColor,
              borderRadius: BorderRadius.circular(12)),
          child: isAdd
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: white,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                        children: [
                          TextSpan(
                            text: "In Card",
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   "In Card",
                    //   style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16,
                    //         color: white,
                    //       ),
                    // )
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                            style:
                                Helper(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                            children: [
                              TextSpan(
                                text: "Add to Card",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
