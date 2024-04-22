import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/flash_sale/widgets/timer_widget.dart';

class FlashSaleTimerView extends StatelessWidget {
  final Duration? eventDuration;
  const FlashSaleTimerView({super.key, this.eventDuration});

  @override
  Widget build(BuildContext context) {
    int? days, hours, minutes, seconds;
    if (eventDuration != null) {
      days = eventDuration!.inDays;
      hours = eventDuration!.inHours - days * 24;
      minutes = eventDuration!.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = eventDuration!.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
    }
    return eventDuration != null ? Row(children: [

      TimerWidget(
        timeCount: days ?? 0,
        timeUnit: 'days'.tr,
      ),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      TimerWidget(
        timeCount: hours ?? 0,
        timeUnit: 'hours'.tr,
      ),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      TimerWidget(
        timeCount: minutes ?? 0,
        timeUnit: 'mins'.tr,
      ),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      TimerWidget(
        timeCount: seconds ?? 0,
        timeUnit: 'sec'.tr,
      ),

    ]) : const SizedBox();
  }
}
