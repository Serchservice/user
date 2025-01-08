import 'package:user/library.dart';

class RequestSearch {
  final SerchCategory? category;
  final SelectedMedia? audio;
  final Specialization? special;
  final String description;
  final String car;
  final Address address;
  final bool isDrive;
  final List<ShoppingItem> shoppingItems;

  RequestSearch({
    this.description = "",
    this.audio,
    this.category,
    this.car = "",
    this.special,
    required this.address,
    this.shoppingItems = const [],
    this.isDrive = false
  });

  factory RequestSearch.fromJson(Map<String, dynamic> json) {
    List<ShoppingItem> items = [];
    if(json["shopping_items"] != null) {
      List<dynamic> itemList = json["shopping_items"];
      items = itemList.map((data) => ShoppingItem.fromJson(data)).toList();
    }

    return RequestSearch(
      description: json["description"] ?? "",
      audio: json["audio"] != null ? SelectedMedia.fromJson(json["audio"]) : null,
      category: json["category"] != null ? SerchCategory.fromJson(json["category"]) : null,
      special: json["special"] != null ? Specialization.fromJson(json["special"]) : null,
      car: json["car"] ?? "",
      address: Address.fromJson(json["address"]),
      shoppingItems: items,
      isDrive: json["is_drive"]
    );
  }

  RequestSearch copyWith({
    SerchCategory? request,
    SerchCategory? category,
    SelectedMedia? audio,
    Specialization? special,
    String? description,
    String? car,
    Address? address,
    List<ShoppingItem>? shoppingItems,
    bool? isDrive
  }) {
    return RequestSearch(
      category: category ?? this.category,
      audio: audio ?? this.audio,
      special: special ?? this.special,
      description: description ?? this.description,
      car: car ?? this.car,
      address: address ?? this.address,
      shoppingItems: shoppingItems ?? this.shoppingItems,
      isDrive: isDrive ?? this.isDrive
    );
  }

  bool get isSearch => special != null;
  bool get hasContent => description.isNotEmpty || (audio != null && (audio!.path.isNotEmpty || audio!.data != null));

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "audio": audio?.toJson(),
      "category": category?.toJson(),
      "special": special?.toJson(),
      "car": car,
      "address": address.toJson(),
      "is_drive": isDrive,
      "shopping_items": shoppingItems.map((data) => data.toJson()).toList()
    };
  }

  factory RequestSearch.empty() {
    return RequestSearch(address: Address.empty());
  }
}