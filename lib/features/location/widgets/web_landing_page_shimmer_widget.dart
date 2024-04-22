import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/util/dimensions.dart';

class WebLandingPageShimmerWidget extends StatelessWidget {
  const WebLandingPageShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(children: [

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Colors.grey[300],
                ),
                child: Row(children: [
                  const SizedBox(width: 40),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(
                      height: 30, width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Container(
                      height: 20, width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ])),
                ]),
              ),
            ),
            const SizedBox(height: 20),

            Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child: Stack(children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.grey[300],
                  ),
                  child: Row(children: [
                    Expanded(flex: 3, child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(children: [

                        Container(
                          height: 70, width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Container(
                            height: 20, width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ]),
                    )),
                    Expanded(flex: 7, child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),

                      child: Row(children: [

                        Expanded(
                          child: Container(
                            height: 60,
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Icon(Icons.my_location, color: Colors.grey[300]),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Container(
                          height: 60, width: 150,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Container(
                            height: 15, width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Container(
                          height: 60, width: 150,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Container(
                            height: 15, width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ]),
                    )),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 40),

            Shimmer(
              enabled: true,
              duration: const Duration(seconds: 2),
              child: Container(
                height: 20, width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Shimmer(
              enabled: true,
              duration: const Duration(seconds: 2),
              child: Container(
                height: 15, width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 40),


            Shimmer(
              enabled: true,
              duration: const Duration(seconds: 2),
              child: SizedBox(height: 450, child: Stack(children: [
                  PageView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const SizedBox(height: 80),
                            Container(
                              height: 20, width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Colors.grey[300],
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                          ])),
                          Container(
                            height: 450, width: 450,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Colors.grey[300],
                            ),
                          ),
                        ]),
                      );
                    },
                  ),

                Positioned(top: 0, left: 0, child: SizedBox(height: 75, child: Container(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                        child: Column(children: [
                          Container(
                            height: 45, width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Colors.grey[300],
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                ))),
                ])),
            ),
            const SizedBox(height: 40),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Container(
                  height: 150, alignment: Alignment.center,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.grey[300],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(
                      height: 45, width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Container(
                      height: 20, width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),

                  ]),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: Container(
                  height: 150, alignment: Alignment.center,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.grey[300],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(
                      height: 45, width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Container(
                      height: 20, width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),

                  ]),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: Container(
                  height: 150, alignment: Alignment.center,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.grey[300],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(
                      height: 45, width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Container(
                      height: 20, width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),

                  ]),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),

              Expanded(
                child: Container(
                  height: 150, alignment: Alignment.center,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Colors.grey[300],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Container(
                      height: 45, width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Container(
                      height: 20, width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).cardColor,
                      ),
                    ),

                  ]),
                ),
              ),
            ]),

          ]),
        ),
      ),
    );
  }
}
