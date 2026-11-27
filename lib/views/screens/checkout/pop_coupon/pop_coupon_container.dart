import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/custom_image.dart';

class PopCouponContainer extends StatelessWidget {
  const PopCouponContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => pop(context),
                  child: SvgPicture.asset(
                    Assets.svgsCrossCirlce,
                  ),
                )
              ],
            ),
            const CustomImage(
              path: Assets.imagesCongratulationsApplyCoupon,
              fit: BoxFit.cover,
              height: 48,
              width: 49,
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "Congratulations!",
              style: Helper(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 11,
            ),
            Text(
              "${productController.cardModel?.couponValue ?? ""} Instant\n Discount ",
              style: Helper(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "Applicable over & above Coupons",
              style: Helper(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 26,
            ),
          ],
        ),
      );
    });
  }
}
