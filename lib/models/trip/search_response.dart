import 'package:user/library.dart';

class SearchResponse {
  SearchResponse({
    required this.best,
    required this.providers,
    required this.shops,
  });

  final Active? best;
  final List<Active> providers;
  final List<SearchShopResponse> shops;

  SearchResponse copyWith({
    Active? best,
    List<Active>? providers,
    List<SearchShopResponse>? shops,
  }) {
    return SearchResponse(
      best: best ?? this.best,
      providers: providers ?? this.providers,
      shops: shops ?? this.shops,
    );
  }

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      best: json["best"] == null ? null : Active.fromJson(json["best"]),
      providers: json["providers"] == null
        ? []
        : List<Active>.from(json["providers"]!.map((x) => Active.fromJson(x))),
      shops: json["shops"] == null
        ? []
        : List<SearchShopResponse>.from(json["shops"]!.map((x) => SearchShopResponse.fromJson(x))),
    );
  }

  factory SearchResponse.empty() {
    return SearchResponse(
      best: Active.empty(),
      providers: [],
      shops: []
    );
  }

  Map<String, dynamic> toJson() => {
    "best": best?.toJson(),
    "providers": providers.map((x) => x.toJson()).toList(),
    "shops": shops.map((x) => x.toJson()).toList(),
  };
}

/*
{
	"best": {
		"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
		"name": "string",
		"avatar": "string",
		"rating": 0,
		"distance": 0,
		"image": "string",
		"category": "string",
		"status": "ONLINE",
		"more": {
			"last_signed_in": "string",
			"number_of_rating": 0,
			"number_of_shops": 0,
			"total_service_trips": 0,
			"total_shared": 0
		},
		"business": {
			"name": "string",
			"description": "string",
			"address": "string",
			"logo": "string"
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
		"distance_in_km": "string",
		"verification_status": "REQUESTED"
	},
	"providers": [
		{
			"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"name": "string",
			"avatar": "string",
			"rating": 0,
			"distance": 0,
			"image": "string",
			"category": "string",
			"status": "ONLINE",
			"more": {
				"last_signed_in": "string",
				"number_of_rating": 0,
				"number_of_shops": 0,
				"total_service_trips": 0,
				"total_shared": 0
			},
			"business": {
				"name": "string",
				"description": "string",
				"address": "string",
				"logo": "string"
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
			"distance_in_km": "string",
			"verification_status": "REQUESTED"
		}
	],
	"shops": [
		{
			"user": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"distance": 0,
			"shop": {
				"name": "string",
				"category": "string",
				"image": "string",
				"logo": "string",
				"open": true,
				"status": "OPEN",
				"rating": 0,
				"id": "string",
				"address": "string",
				"phone": "string",
				"current": {
					"id": 0,
					"day": "string",
					"opening": "string",
					"closing": "string",
					"open": true
				},
				"weekdays": [
					{
						"id": 0,
						"day": "string",
						"opening": "string",
						"closing": "string",
						"open": true
					}
				],
				"services": [
					{
						"id": 0,
						"service": "string"
					}
				]
			},
			"distance_in_km": "string"
		}
	]
}*/