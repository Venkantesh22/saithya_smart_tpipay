
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/card_screen/card_screen.dart';

class CardIcon extends StatelessWidget {
  const CardIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return GestureDetector(
        onTap: () {},
        child: Stack(
          children: [
            IconButton(
              onPressed: () {
                navigate(context: context, page: const CardScreen());
              },
              icon: const Icon(
                Icons.shopping_cart_rounded,
                color: black,
              ),
            ),
            (productController.cardModel?.products?.isNotEmpty ?? false)
                ? Positioned(
                    right: 4,
                    top: 6,
                    child: CircleAvatar(
                      radius: 8,
                      child: Center(
                        child: Text(
                          (productController.cardModel?.products?.length ?? 0)
                              .toString(),
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                      ),
                    ))
                : const SizedBox()
          ],
        ),
      );
    });
  }
}
