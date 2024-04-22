import 'package:sixam_mart/features/taxi_booking/controllers/rider_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/common/widgets/footer_view.dart';
import 'package:sixam_mart/common/widgets/no_data_screen.dart';
import 'package:sixam_mart/common/widgets/paginated_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/trip_history_item.dart';


class TripHistoryList extends StatelessWidget {
  final String type;
  const TripHistoryList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: GetBuilder<RiderController>(builder: (riderController) {


        return riderController.runningTrip != null ? riderController.runningTrip!.orders!.data!.isNotEmpty ?
        RefreshIndicator(
          onRefresh: () async {
            await riderController.getRunningTripList(1, isUpdate: true);
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: FooterView(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: PaginatedListView(
                  scrollController: scrollController,
                  onPaginate: (int? offset) => Get.find<RiderController>().getRunningTripList(offset!, isUpdate: true),
                  totalSize: riderController.runningTrip?.totalSize,
                  offset: riderController.runningTrip != null ? int.parse(riderController.runningTrip!.offset!) : null,
                  itemView: ListView.builder(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: riderController.runningTrip!.orders!.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      return TripHistoryItem(trip: riderController.runningTrip!.orders!.data![index]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ) : NoDataScreen(text: 'no_trip_found'.tr, showFooter: true) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
