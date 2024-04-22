class TimeSlotModel {
  int? day;
  DateTime? startTime;
  DateTime? endTime;

  TimeSlotModel({required this.day, required this.startTime, required this.endTime});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
