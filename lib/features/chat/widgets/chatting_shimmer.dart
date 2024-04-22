import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/util/dimensions.dart';

class ChattingShimmer extends StatelessWidget {
  const ChattingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: SizedBox(
        height: Get.height * 0.80,
        child: SingleChildScrollView(
          child: Column(children:[

            Container(margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              height: 65,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                Container(height: 50, width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(100))),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(height: 40, width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
                  ),
                ),

              ]),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              height: 50,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                Container(height: 40, width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomLeft: Radius.circular(Dimensions.radiusDefault)
                    )
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(100))),
                ),

              ],),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: [

                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  height: 80,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault),
                    ),
                  ),
                ),

              ]),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.end, children: [

                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(100)),),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(height: 120, width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault),bottomLeft: Radius.circular(Dimensions.radiusDefault)),
                  ),),

              ])
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              height: 65,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomLeft: Radius.circular(Dimensions.radiusDefault)),
                  ),),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                ),

              ]),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [

                Container(height: 80, width: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomLeft: Radius.circular(Dimensions.radiusDefault))
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300],  borderRadius: const BorderRadius.all(Radius.circular(100))),
                ),

              ]),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              height: 50,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300],  borderRadius: const BorderRadius.all(Radius.circular(100))),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
                  ),
                ),

              ]),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(color: Colors.grey[300],  borderRadius: const BorderRadius.all(Radius.circular(100))),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusDefault),topLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault),bottomLeft: Radius.circular(Dimensions.radiusDefault)),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(100)),
                    ),
                  ),

                ],
              ),
            ),

          ]),
        ),
      ),
    );
  }
}