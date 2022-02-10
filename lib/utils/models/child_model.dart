const String tableWishlist = 'wishlist';

class ProductFields {
  static const List<String> values = [
    countInStock,
    id,
    title,
    description,
    price,
    discountedPrice,
    imageUrl,
    isFavourite,
    storeID
  ];

  static const String countInStock = 'countInStock';
  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String price = 'price';
  static const String discountedPrice = 'discountedPrice';
  static const String imageUrl = 'imageUrl';
  static const String isFavourite = 'isFavourite';
  static const String storeID = "storeID";
}

class ChildModel {
  int countInStock;
  String id;
  String title;
  String description;
  int price;
  int discountedPrice;
  String imageUrl;
  bool isFavourite;
  String storeID;

  ChildModel(
    this.countInStock,
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountedPrice,
    this.imageUrl,
    this.isFavourite,
    this.storeID,
  );

  Map<String, Object?> toJson() => {
        ProductFields.countInStock: countInStock,
        ProductFields.id: id,
        ProductFields.title: title,
        ProductFields.description: description,
        ProductFields.price: price,
        ProductFields.discountedPrice: discountedPrice,
        ProductFields.imageUrl: imageUrl,
        ProductFields.isFavourite: isFavourite ? 1 : 0,
        ProductFields.storeID: storeID,
      };

  static ChildModel fromJson(Map<String, Object?> json) => ChildModel(
        json[ProductFields.countInStock] as int,
        json[ProductFields.id] as String,
        json[ProductFields.title] as String,
        json[ProductFields.description] as String,
        json[ProductFields.price] as int,
        json[ProductFields.discountedPrice] as int,
        json[ProductFields.imageUrl] as String,
        json[ProductFields.isFavourite] == 1,
        json[ProductFields.storeID] as String,
      );
}
