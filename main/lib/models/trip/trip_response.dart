import 'package:flutter/material.dart';
import 'package:user/library.dart';

class TripResponse {
  TripResponse({
    required this.id,
    required this.label,
    required this.mode,
    required this.snt,
    required this.skill,
    required this.car,
    required this.category,
    required this.image,
    required this.audio,
    required this.problem,
    required this.address,
    required this.placeId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.provider,
    required this.shared,
    required this.timelines,
    required this.quotations,
    required this.authentication,
    required this.tryServicePaymentAgain,
    required this.serviceFee,
    required this.userShareFee,
    required this.pendingPaymentData,
    required this.tryPaymentAgain,
    required this.shoppingLocation,
    required this.shoppingItems,
    required this.totalAmount,
    required this.totalShoppingAmount,
    required this.totalAmountSpentInShopping,
    required this.createdAt,
    required this.updatedAt,
    required this.rating,
    required this.amount,
    required this.type,
    required this.showCancel,
    required this.showAuth,
    required this.showEnd,
    required this.showShare,
    required this.showGrant,
    required this.showDeny,
    required this.showLeave,
    required this.location,
    required this.requestedId
  });

  final String id;
  final String label;
  final String mode;
  final String snt;
  final String skill;
  final String car;
  final String category;
  final String image;
  final String audio;
  final String problem;
  final String address;
  final String placeId;
  final double latitude;
  final double longitude;
  final String status;
  final UserResponse? provider;
  final SharedTripResponse? shared;
  final List<TimelineResponse> timelines;
  final List<QuotationResponse> quotations;
  final String authentication;
  final bool tryServicePaymentAgain;
  final String serviceFee;
  final String userShareFee;
  final Payment? pendingPaymentData;
  final bool tryPaymentAgain;
  final ShoppingLocationResponse? shoppingLocation;
  final List<ShoppingItemResponse> shoppingItems;
  final int totalAmount;
  final String totalShoppingAmount;
  final String totalAmountSpentInShopping;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;
  final String amount;
  final String type;
  final bool showCancel;
  final bool showAuth;
  final bool showEnd;
  final bool showShare;
  final bool showGrant;
  final bool showDeny;
  final bool showLeave;
  final MapViewResponse location;
  final String requestedId;

  TripResponse copyWith({
    String? id,
    String? label,
    String? mode,
    String? snt,
    String? skill,
    String? image,
    String? car,
    String? category,
    String? audio,
    String? problem,
    String? address,
    String? placeId,
    double? latitude,
    double? longitude,
    String? status,
    UserResponse? provider,
    SharedTripResponse? shared,
    List<TimelineResponse>? timelines,
    List<QuotationResponse>? quotations,
    String? authentication,
    bool? tryServicePaymentAgain,
    String? serviceFee,
    String? userShareFee,
    Payment? pendingPaymentData,
    bool? tryPaymentAgain,
    ShoppingLocationResponse? shoppingLocation,
    List<ShoppingItemResponse>? shoppingItems,
    int? totalAmount,
    String? totalShoppingAmount,
    String? totalAmountSpentInShopping,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    String? amount,
    String? type,
    bool? showCancel,
    bool? showAuth,
    bool? showEnd,
    bool? showShare,
    bool? showGrant,
    bool? showDeny,
    bool? showLeave,
    MapViewResponse? location,
    String? requestedId,
  }) {
    return TripResponse(
      id: id ?? this.id,
      label: label ?? this.label,
      mode: mode ?? this.mode,
      image: image ?? this.image,
      snt: snt ?? this.snt,
      skill: skill ?? this.skill,
      car: car ?? this.car,
      category: category ?? this.category,
      audio: audio ?? this.audio,
      problem: problem ?? this.problem,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      shared: shared ?? this.shared,
      timelines: timelines ?? this.timelines,
      quotations: quotations ?? this.quotations,
      authentication: authentication ?? this.authentication,
      tryServicePaymentAgain: tryServicePaymentAgain ?? this.tryServicePaymentAgain,
      serviceFee: serviceFee ?? this.serviceFee,
      userShareFee: userShareFee ?? this.userShareFee,
      pendingPaymentData: pendingPaymentData ?? this.pendingPaymentData,
      tryPaymentAgain: tryPaymentAgain ?? this.tryPaymentAgain,
      shoppingLocation: shoppingLocation ?? this.shoppingLocation,
      shoppingItems: shoppingItems ?? this.shoppingItems,
      totalAmount: totalAmount ?? this.totalAmount,
      totalShoppingAmount: totalShoppingAmount ?? this.totalShoppingAmount,
      totalAmountSpentInShopping: totalAmountSpentInShopping ?? this.totalAmountSpentInShopping,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      showCancel: showCancel ?? this.showCancel,
      showAuth: showAuth ?? this.showAuth,
      showEnd: showEnd ?? this.showEnd,
      showShare: showShare ?? this.showShare,
      showGrant: showGrant ?? this.showGrant,
      showDeny: showDeny ?? this.showDeny,
      showLeave: showLeave ?? this.showLeave,
      location: location ?? this.location,
      requestedId: requestedId ?? this.requestedId
    );
  }

  factory TripResponse.fromJson(Map<String, dynamic> json){
    return TripResponse(
      id: json["id"] ?? "",
      label: json['label'] ?? "",
      mode: json["mode"] ?? "",
      image: json["image"] ?? "",
      snt: json["snt"] ?? "",
      skill: json["skill"] ?? "",
      car: json["car"] ?? "",
      category: json["category"] ?? "",
      audio: json["audio"] ?? "",
      problem: json["problem"] ?? "",
      address: json["address"] ?? "",
      placeId: json["placeId"] ?? "",
      latitude: json["latitude"] ?? 0.0,
      longitude: json["longitude"] ?? 0.0,
      status: json["status"] ?? "",
      provider: json["provider"] == null ? null : UserResponse.fromJson(json["provider"]),
      shared: json["shared"] == null ? null : SharedTripResponse.fromJson(json["shared"]),
      timelines: json["timelines"] == null ? [] : List<TimelineResponse>.from(json["timelines"]!.map((x) => TimelineResponse.fromJson(x))),
      quotations: json["quotations"] == null ? [] : List<QuotationResponse>.from(json["quotations"]!.map((x) => QuotationResponse.fromJson(x))),
      authentication: json["authentication"] ?? "",
      tryServicePaymentAgain: json["try_service_payment_again"] ?? false,
      serviceFee: json["service_fee"] ?? "",
      userShareFee: json["user_share_fee"] ?? "",
      pendingPaymentData: json["pending_payment_data"] == null ? null : Payment.fromJson(json["pending_payment_data"]),
      tryPaymentAgain: json["try_payment_again"] ?? false,
      shoppingLocation: json["shopping_location"] == null ? null : ShoppingLocationResponse.fromJson(json["shopping_location"]),
      shoppingItems: json["shopping_items"] == null ? [] : List<ShoppingItemResponse>.from(json["shopping_items"]!.map((x) => ShoppingItemResponse.fromJson(x))),
      totalAmount: json["total_amount"] ?? 0,
      totalShoppingAmount: json["total_shopping_amount"] ?? "",
      totalAmountSpentInShopping: json["total_amount_spent_in_shopping"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
      rating: json["rating"]?.toDouble() ?? 0.0,
      amount: json["amount"] ?? "",
      type: json["type"] ?? "",
      showCancel: json["show_cancel"] ?? false,
      showAuth: json["show_auth"] ?? false,
      showEnd: json["show_end"] ?? false,
      showShare: json["show_share"] ?? false,
      showGrant: json["show_grant"] ?? false,
      showDeny: json["show_deny"] ?? false,
      showLeave: json["show_leave"] ?? false,
      requestedId: json["requested_id"] ?? "",
      location: json["location"] == null ? MapViewResponse.empty() : MapViewResponse.fromJson(json["location"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "amount": amount,
    "type": type,
    "mode": mode,
    "snt": snt,
    "image": image,
    "skill": skill,
    "car": car,
    "category": category,
    "audio": audio,
    "problem": problem,
    "address": address,
    "placeId": placeId,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "provider": provider?.toJson(),
    "shared": shared?.toJson(),
    "timelines": timelines.map((x) => x.toJson()).toList(),
    "quotations": quotations.map((x) => x.toJson()).toList(),
    "authentication": authentication,
    "try_service_payment_again": tryServicePaymentAgain,
    "service_fee": serviceFee,
    "user_share_fee": userShareFee,
    "pending_payment_data": pendingPaymentData?.toJson(),
    "try_payment_again": tryPaymentAgain,
    "shopping_location": shoppingLocation?.toJson(),
    "shopping_items": shoppingItems.map((x) => x.toJson()).toList(),
    "total_amount": totalAmount,
    "total_shopping_amount": totalShoppingAmount,
    "total_amount_spent_in_shopping": totalAmountSpentInShopping,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "rating": rating,
    "show_cancel": showCancel,
    "show_auth": showAuth,
    "show_end": showEnd,
    "show_share": showShare,
    "show_grant": showGrant,
    "show_deny": showDeny,
    "show_leave": showLeave,
    "location": location.toJson(),
    "requested_id": ""
  };

  bool get isWaiting => status == "WAITING";
  bool get isClosed => status == "CLOSED";
  bool get isUnfulfilled => status == "UNFULFILLED";
  bool get isActive => status == "ACTIVE";
  bool get isRequest => type == "REQUEST";

  static Color background(String status) {
    switch (status.toLowerCase()) {
      case "waiting":
        return Colors.yellowAccent; // Light Yellow
      case "active":
        return Colors.greenAccent; // Light Green
      case "closed":
        return Colors.orangeAccent; // Light Red
      default:
        return Colors.white; // Default to white if status is unknown
    }
  }

  static Color text(String status) {
    switch (status.toLowerCase()) {
      case "waiting":
        return Colors.yellow[900] ?? Colors.black12; // Light Yellow
      case "active":
        return Colors.green[900] ?? Colors.black12; // Light Green
      case "closed":
        return Colors.orange[900] ?? Colors.black12; // Light Red
      default:
        return Colors.white; // Default to white if status is unknown
    }
  }

  factory TripResponse.empty() {
    return TripResponse.fromJson({
      "id": "",
      "label": "",
      "mode": "",
      "snt": "string",
      "skill": "string",
      "car": "string",
      "category": "",
      "audio": "string",
      "problem": "string",
      "address": "string",
      "rating": 0.0,
      "placeId": "string",
      "latitude": 0.0,
      "longitude": 0.0,
      "status": "ACTIVE",
      "provider": null,
      "shared": null,
      "timelines": [],
      "authentication": "string",
      "try_service_payment_again": true,
      "service_fee": "string",
      "user_share_fee": "string",
      "pending_payment_data": null,
      "try_payment_again": true,
      "shopping_location": null,
      "shopping_items": [],
      "total_amount": 0,
      "total_shopping_amount": "string",
      "total_amount_spent_in_shopping": "string",
      "created_at": "2024-07-25T05:27:18.601Z",
      "updated_at": "2024-07-25T05:27:18.601Z",
      "location": null,
      "requested_id": ""
    });
  }
}
/*
{
	"id": "string",
	"mode": "FROM_GUEST",
	"snt": "string",
	"skill": "string",
	"car": "string",
	"category": "MECHANIC",
	"audio": "string",
	"problem": "string",
	"address": "string",
	"placeId": "string",
	"latitude": 0,
	"longitude": 0,
	"status": "ACTIVE",
	"show_cancel": true,
	"show_auth": true,
	"show_end": true,
	"show_share": true,
	"show_grant": true,
	"show_deny": true,
	"show_leave": true,
	"provider": {
		"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
		"category": "string",
		"image": "string",
		"gender": "string",
		"status": "string",
		"avatar": "string",
		"certificate": "string",
		"rating": 0,
		"more": {
			"last_signed_in": "string",
			"number_of_rating": 0,
			"number_of_shops": 0,
			"total_service_trips": 0,
			"total_shared": 0
		},
		"specializations": [
			{
				"id": 0,
				"special": "string",
				"category": "string",
				"image": "string",
				"avatar": "string"
			}
		],
		"first_name": "string",
		"last_name": "string",
		"email_address": "string",
		"phone_info": {
			"phone_number": "string",
			"country_code": "string",
			"iso_code": "string",
			"country": "string"
		},
		"verification_status": "REQUESTED",
		"business_information": {
			"name": "string",
			"description": "string",
			"address": "string",
			"logo": "string"
		}
	},
	"user": {
		"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
		"category": "string",
		"image": "string",
		"gender": "string",
		"status": "string",
		"avatar": "string",
		"certificate": "string",
		"rating": 0,
		"more": {
			"last_signed_in": "string",
			"number_of_rating": 0,
			"number_of_shops": 0,
			"total_service_trips": 0,
			"total_shared": 0
		},
		"specializations": [
			{
				"id": 0,
				"special": "string",
				"category": "string",
				"image": "string",
				"avatar": "string"
			}
		],
		"first_name": "string",
		"last_name": "string",
		"email_address": "string",
		"phone_info": {
			"phone_number": "string",
			"country_code": "string",
			"iso_code": "string",
			"country": "string"
		},
		"verification_status": "REQUESTED",
		"business_information": {
			"name": "string",
			"description": "string",
			"address": "string",
			"logo": "string"
		}
	},
	"guest": {
		"id": "string",
		"gender": "string",
		"avatar": "string",
		"confirmed": true,
		"link": {
			"link": "string",
			"label": "string",
			"image": "string",
			"amount": "string",
			"status": "string",
			"category": "string",
			"provider": {
				"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
				"name": "string",
				"avatar": "string",
				"category": "string",
				"rating": 0
			},
			"user": {
				"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
				"name": "string",
				"avatar": "string",
				"category": "string",
				"rating": 0
			},
			"link_id": "string",
			"created_at": "2024-07-25T05:27:18.601Z"
		},
		"statuses": [
			{
				"user": "string",
				"amount": "string",
				"status": "string",
				"label": "string",
				"rating": 0,
				"trip": "string",
				"created_at": "2024-07-25T05:27:18.601Z"
			}
		],
		"email_address": "string",
		"first_name": "string",
		"last_name": "string",
		"joined_at": "string"
	},
	"shared": {
		"id": 0,
		"category": "string",
		"profile": {
			"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"category": "string",
			"image": "string",
			"gender": "string",
			"status": "string",
			"avatar": "string",
			"certificate": "string",
			"rating": 0,
			"more": {
				"last_signed_in": "string",
				"number_of_rating": 0,
				"number_of_shops": 0,
				"total_service_trips": 0,
				"total_shared": 0
			},
			"specializations": [
				{
					"id": 0,
					"special": "string",
					"category": "string",
					"image": "string",
					"avatar": "string"
				}
			],
			"first_name": "string",
			"last_name": "string",
			"email_address": "string",
			"phone_info": {
				"phone_number": "string",
				"country_code": "string",
				"iso_code": "string",
				"country": "string"
			},
			"verification_status": "REQUESTED",
			"business_information": {
				"name": "string",
				"description": "string",
				"address": "string",
				"logo": "string"
			}
		},
		"timelines": [
			{
				"status": "REQUESTED",
				"header": "string",
				"description": "string"
			}
		],
		"phone_number": "string",
		"first_name": "string",
		"last_name": "string",
		"cancel_reason": "string"
	},
	"timelines": [
		{
			"status": "REQUESTED",
			"header": "string",
			"description": "string"
		}
	],
	"quotations": [
		{
			"id": 0,
			"amount": "string",
			"account": "string"
		}
	],
	"authentication": "string",
	"is_authenticated": true,
	"shared_authentication": "string",
	"is_shared_authenticated": true,
	"trip_accepted": true,
	"try_service_payment_again": true,
	"service_fee": "string",
	"user_share_fee": "string",
	"pending_payment_data": {
		"authorization_url": "string",
		"access_code": "string",
		"reference": "string"
	},
	"try_payment_again": true,
	"shopping_location": {
		"address": "string",
		"latitude": 0,
		"longitude": 0,
		"place_id": "string"
	},
	"shopping_items": [
		{
			"id": 0,
			"item": "string",
			"quantity": 0,
			"amount": "string",
			"slip": "string"
		}
	],
	"total_amount": 0,
	"total_shopping_amount": "string",
	"total_amount_spent_in_shopping": "string",
	"created_at": "2024-07-25T05:27:18.601Z",
	"updated_at": "2024-07-25T05:27:18.601Z"
}*/