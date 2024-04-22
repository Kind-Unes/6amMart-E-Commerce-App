class PaginatedRideModel {
  int? totalSize;
  String? limit;
  int? offset;
  List<RideRequestModel>? rides;

  PaginatedRideModel({this.totalSize, this.limit, this.offset, this.rides});

  PaginatedRideModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['data'] != null) {
      rides = [];
      json['data'].forEach((v) {
        rides!.add(RideRequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (rides != null) {
      data['data'] = rides!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class RideRequestModel {
  int? id;
  String? rideCategory;
  String? zone;
  String? rideStatus;
  PickupPoint? pickupPoint;
  String? pickupAddress;
  String? pickupTime;
  PickupPoint? dropoffPoint;
  String? dropoffAddress;
  String? dropoffTime;
  double? estimatedTime;
  double? estimatedFare;
  double? estimatedDistance;
  double? actualTime;
  double? actualFare;
  double? actualDistance;
  double? totalFare;
  double? tax;
  String? customerName;
  String? customerImage;
  String? otp;
  Rider? rider;
  String? createdAt;
  String? updatedAt;

  RideRequestModel(
      {this.id,
        this.rideCategory,
        this.zone,
        this.rideStatus,
        this.pickupPoint,
        this.pickupAddress,
        this.pickupTime,
        this.dropoffPoint,
        this.dropoffAddress,
        this.dropoffTime,
        this.estimatedTime,
        this.estimatedFare,
        this.estimatedDistance,
        this.actualTime,
        this.actualFare,
        this.actualDistance,
        this.totalFare,
        this.tax,
        this.customerName,
        this.customerImage,
        this.otp,
        this.rider,
        this.createdAt,
        this.updatedAt,
      });

  RideRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rideCategory = json['ride_category'];
    zone = json['zone'];
    rideStatus = json['ride_status'];
    pickupPoint = json['pickup_point'] != null ? PickupPoint.fromJson(json['pickup_point']) : null;
    pickupAddress = json['pickup_address'];
    pickupTime = json['pickup_time'];
    dropoffPoint = json['dropoff_point'] != null ? PickupPoint.fromJson(json['dropoff_point']) : null;
    dropoffAddress = json['dropoff_address'];
    dropoffTime = json['dropoff_time'];
    estimatedTime = json['estimated_time'].toDouble();
    estimatedFare = json['estimated_fare'].toDouble();
    estimatedDistance = json['estimated_distance'].toDouble();
    actualTime = json['actual_time']?.toDouble();
    actualFare = json['actual_fare']?.toDouble();
    actualDistance = json['actual_distance']?.toDouble();
    totalFare = json['total_fare']?.toDouble();
    tax = json['tax'].toDouble();
    customerName = json['customer_name'];
    customerImage = json['customer_image'];
    otp = json['otp'].toString();
    rider = json['rider'] != null ? Rider.fromJson(json['rider']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ride_category'] = rideCategory;
    data['zone'] = zone;
    data['ride_status'] = rideStatus;
    if (pickupPoint != null) {
      data['pickup_point'] = pickupPoint!.toJson();
    }
    data['pickup_address'] = pickupAddress;
    data['pickup_time'] = pickupTime;
    if (dropoffPoint != null) {
      data['dropoff_point'] = dropoffPoint!.toJson();
    }
    data['dropoff_address'] = dropoffAddress;
    data['dropoff_time'] = dropoffTime;
    data['estimated_time'] = estimatedTime;
    data['estimated_fare'] = estimatedFare;
    data['estimated_distance'] = estimatedDistance;
    data['actual_time'] = actualTime;
    data['actual_fare'] = actualFare;
    data['actual_distance'] = actualDistance;
    data['total_fare'] = totalFare;
    data['tax'] = tax;
    data['customer_name'] = customerName;
    data['customer_image'] = customerImage;
    data['otp'] = otp;
    if (rider != null) {
      data['rider'] = rider!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PickupPoint {
  String? type;
  List<double>? coordinates;

  PickupPoint({this.type, this.coordinates});

  PickupPoint.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Rider {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? identityNumber;
  String? identityType;
  String? identityImage;
  String? image;
  String? fcmToken;
  int? zoneId;
  String? createdAt;
  String? updatedAt;
  bool? status;
  int? active;
  int? earning;
  int? currentOrders;
  String? type;
  int? storeId;
  String? applicationStatus;
  int? orderCount;
  int? assignedOrderCount;
  int? delivery;
  int? rideSharing;
  String? vehicleRegNo;
  String? vehicleRc;
  String? vehicleOwnerNoc;
  int? rideZoneId;
  int? rideCategoryId;
  double? avgRating;
  int? ratingCount;
  String? lat;
  String? lng;
  String? location;

  Rider(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.identityNumber,
        this.identityType,
        this.identityImage,
        this.image,
        this.fcmToken,
        this.zoneId,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.active,
        this.earning,
        this.currentOrders,
        this.type,
        this.storeId,
        this.applicationStatus,
        this.orderCount,
        this.assignedOrderCount,
        this.delivery,
        this.rideSharing,
        this.vehicleRegNo,
        this.vehicleRc,
        this.vehicleOwnerNoc,
        this.rideZoneId,
        this.rideCategoryId,
        this.avgRating,
        this.ratingCount,
        this.lat,
        this.lng,
        this.location});

  Rider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    identityNumber = json['identity_number'];
    identityType = json['identity_type'];
    identityImage = json['identity_image'];
    image = json['image'];
    fcmToken = json['fcm_token'];
    zoneId = json['zone_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    active = json['active'];
    earning = json['earning'];
    currentOrders = json['current_orders'];
    type = json['type'];
    storeId = json['store_id'];
    applicationStatus = json['application_status'];
    orderCount = json['order_count'];
    assignedOrderCount = json['assigned_order_count'];
    delivery = json['delivery'];
    rideSharing = json['ride_sharing'];
    vehicleRegNo = json['vehicle_reg_no'];
    vehicleRc = json['vehicle_rc'];
    vehicleOwnerNoc = json['vehicle_owner_noc'];
    rideZoneId = json['ride_zone_id'];
    rideCategoryId = json['ride_category_id'];
    avgRating = json['avg_rating']?.toDouble();
    ratingCount = json['rating_count'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['identity_number'] = identityNumber;
    data['identity_type'] = identityType;
    data['identity_image'] = identityImage;
    data['image'] = image;
    data['fcm_token'] = fcmToken;
    data['zone_id'] = zoneId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['active'] = active;
    data['earning'] = earning;
    data['current_orders'] = currentOrders;
    data['type'] = type;
    data['store_id'] = storeId;
    data['application_status'] = applicationStatus;
    data['order_count'] = orderCount;
    data['assigned_order_count'] = assignedOrderCount;
    data['delivery'] = delivery;
    data['ride_sharing'] = rideSharing;
    data['vehicle_reg_no'] = vehicleRegNo;
    data['vehicle_rc'] = vehicleRc;
    data['vehicle_owner_noc'] = vehicleOwnerNoc;
    data['ride_zone_id'] = rideZoneId;
    data['ride_category_id'] = rideCategoryId;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['lat'] = lat;
    data['lng'] = lng;
    data['location'] = location;
    return data;
  }
}