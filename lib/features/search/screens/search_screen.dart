import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/search/controllers/search_controller.dart' as search;
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:sixam_mart/features/search/widgets/filter_widget.dart';
import 'package:sixam_mart/features/search/widgets/search_field_widget.dart';
import 'package:sixam_mart/features/search/widgets/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/store/widgets/bottom_cart_widget.dart';

class SearchScreen extends StatefulWidget {
  final String? queryText;
  const SearchScreen({super.key, required this.queryText});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  final TextEditingController _searchController = TextEditingController();
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _isLoggedIn = AuthHelper.isLoggedIn();
    Get.find<search.SearchController>().setSearchMode(true, canUpdate: false);
    if(_isLoggedIn) {
      Get.find<search.SearchController>().getSuggestedItems();
    }
    Get.find<search.SearchController>().getHistoryList();
    if(widget.queryText!.isNotEmpty) {
      _actionSearch(true, widget.queryText, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if(Get.find<search.SearchController>().isSearchMode) {
          return;
        }else {
          Get.find<search.SearchController>().setSearchMode(true);
        }
      },
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
        body: SafeArea(child: Padding(
          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: GetBuilder<search.SearchController>(builder: (searchController) {
            _searchController.text = searchController.searchText!;
            return Column(children: [
              ResponsiveHelper.isDesktop(context) ? Container(
                width : double.infinity,
                color: Theme.of(context).primaryColor.withOpacity(0.10),
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Text('search_items_and_stores'.tr, style: robotoMedium),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      SizedBox(width: Dimensions.webMaxWidth, child: GetBuilder<search.SearchController>(builder: (searchController) {
                        _searchController.text = searchController.searchHomeText!;
                        return SearchFieldWidget(
                          controller: _searchController,
                          hint: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                              ? 'search_food_or_restaurant'.tr : 'search_item_or_store'.tr,
                          suffixIcon: searchController.searchHomeText!.isNotEmpty ? Icons.cancel : Icons.search,
                          iconColor: Theme.of(context).disabledColor,
                          filledColor: Theme.of(context).colorScheme.background,
                          iconPressed: () {
                            if(searchController.searchHomeText!.isNotEmpty) {
                              _searchController.text = '';
                              searchController.setSearchMode(true);
                              searchController.clearSearchHomeText();
                            }else {
                              searchData();
                            }
                          },
                          onSubmit: (text) => searchData(),
                        );
                      })),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      !searchController.isSearchMode ?
                      Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 160,
                                color: Colors.transparent,
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorColor: Theme.of(context).primaryColor,
                                  indicatorWeight: 3,
                                  labelColor: Theme.of(context).primaryColor,
                                  unselectedLabelColor: Theme.of(context).disabledColor,
                                  unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                  labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                                  labelPadding: const EdgeInsets.symmetric(horizontal: Dimensions.radiusDefault, vertical: 0 ),
                                  isScrollable: true,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: [
                                    Tab(text: 'item'.tr),
                                    Tab(text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurants'.tr : 'stores'.tr),
                                  ],
                                ),
                              ),
                              
                              InkWell(
                                onTap: () {
                                  _actionSearch(false, _searchController.text.trim(), false);
                                },
                                child: Image.asset(Images.filter, height: 28, width: 28))
                            ],
                          )
                        ),
                      ) : const SizedBox(),
                    ],
                  ),
                ),
              ) : const SizedBox(),

              widget.queryText!.isNotEmpty ? const SizedBox() : Center(child: ResponsiveHelper.isDesktop(context) ? const SizedBox() : SizedBox(width: Dimensions.webMaxWidth, child: Row(children: [
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: SearchFieldWidget(
                  controller: _searchController,
                  hint: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                      ? 'search_food_or_restaurant'.tr : 'search_item_or_store'.tr,
                  suffixIcon: !searchController.isSearchMode ? Icons.filter_list : Icons.search,
                  iconPressed: () => _actionSearch(false, _searchController.text.trim(), false),
                  onSubmit: (text) => _actionSearch(true, _searchController.text.trim(), false),
                )),
                CustomButton(
                  onPressed: () {
                    if(searchController.isSearchMode) {
                      Get.back();
                    } else {
                      searchController.setSearchMode(true);
                      searchController.setStore(false);
                    }
                  },
                  buttonText: 'cancel'.tr,
                  transparent: true,
                  width: 80,
                ),
              ]))),

              Expanded(child: searchController.isSearchMode ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: FooterView(
                  child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    searchController.historyList.isNotEmpty ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(ResponsiveHelper.isDesktop(context) ? 'recent_searches'.tr : 'history'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      InkWell(
                        onTap: () => searchController.clearSearchHistory(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 4),
                          child: Text('clear_all'.tr, style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                          )),
                        ),
                      ),
                    ]) : const SizedBox(),
                    SizedBox(
                      height: ResponsiveHelper.isDesktop(context) ? 36 : null,
                      child: ListView.builder(
                        itemCount: searchController.historyList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: ResponsiveHelper.isDesktop(context) ? Axis.horizontal : Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ResponsiveHelper.isDesktop(context) ?
                            Container(
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                             padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.10),
                                border: Border.all(color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              child: InkWell(
                                onTap: () => searchController.searchData(searchController.historyList[index], false),
                                child: Row(
                                  children: [
                                    Text(searchController.historyList[index], style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    InkWell(
                                      onTap: () => searchController.removeHistory(index),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                        child: Icon(Icons.close, color: Theme.of(context).primaryColor, size: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ): Column(children: [
                            Row(children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => searchController.searchData(searchController.historyList[index], false),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                    child: Text(
                                      searchController.historyList[index],
                                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => searchController.removeHistory(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
                                ),
                              )
                            ]),
                            index != searchController.historyList.length-1 ? const Divider() : const SizedBox(),
                          ]);
                        },
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    (_isLoggedIn && searchController.suggestedItemList != null) ? Text(
                      'suggestions'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ) : const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    (_isLoggedIn && searchController.suggestedItemList != null) ? searchController.suggestedItemList!.isNotEmpty ?  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 1, childAspectRatio:  ResponsiveHelper.isMobile(context) ? (1/ 0.4) : (1.8/ 0.1),
                        mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: searchController.suggestedItemList!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.find<ItemController>().navigateToItemPage(searchController.suggestedItemList![index], context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Row(children: [
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImage(
                                  image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}'
                                      '/${searchController.suggestedItemList![index].image}',
                                  width: 45, height: 45, fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              Expanded(child: Text(
                                searchController.suggestedItemList![index].name!,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                              )),
                            ]),
                          ),
                        );
                      },
                    ) : Padding(padding: const EdgeInsets.only(top: 10), child: Text('no_suggestions_available'.tr)) : const SizedBox(),
                  ])),
                ),
                ) : SearchResultWidget(searchText: _searchController.text.trim(), tabController: ResponsiveHelper.isDesktop(context) ? _tabController : null)),
            ]);
          }),
        )),

        bottomNavigationBar: GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.isNotEmpty && !ResponsiveHelper.isDesktop(context) ? const BottomCartWidget() : const SizedBox();
        })
      ),
    );
  }

  void searchData() {
    if (_searchController.text.trim().isEmpty) {
      showCustomSnackBar(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
        ? 'search_food_or_restaurant'.tr : 'search_item_or_store'.tr);
    } else {
      _actionSearch(true, _searchController.text, true);
    }
  }

  void _actionSearch(bool isSubmit, String? queryText, bool fromHome) {
    if(Get.find<search.SearchController>().isSearchMode || isSubmit) {
      if(queryText!.isNotEmpty) {
        Get.find<search.SearchController>().searchData(queryText, fromHome);
      } else {
        showCustomSnackBar(Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
            ? 'search_food_or_restaurant'.tr : 'search_item_or_store'.tr);
      }
    } else {
      List<double?> prices = [];
      if(!Get.find<search.SearchController>().isStore) {
        for (var product in Get.find<search.SearchController>().allItemList!) {
          prices.add(product.price);
        }
        prices.sort();
      }
      double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
      Get.dialog(FilterWidget(maxValue: maxValue, isStore: Get.find<search.SearchController>().isStore));
    }
  }
}
