import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/favourite/controllers/favourite_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';

class AddFavouriteView extends StatelessWidget {
  final Item item;
  final double? top, right;
  final double? left;
  const AddFavouriteView({super.key, required this.item, this.top = 15, this.right = 15, this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, right: right, left: left,
      child: GetBuilder<FavouriteController>(builder: (favouriteController) {
        bool isWished = favouriteController.wishItemIdList.contains(item.id);
        return InkWell(
          onTap: () {
            if(AuthHelper.isLoggedIn()) {
              isWished ? favouriteController.removeFromFavouriteList(item.id, false)
                  : favouriteController.addToFavouriteList(item, null, false);
            }else {
              showCustomSnackBar('you_are_not_logged_in'.tr);
            }
          },
          child: Icon(isWished ? Icons.favorite : Icons.favorite_border, color: Theme.of(context).primaryColor, size: 20),
        );
      }),
    );
  }
}
