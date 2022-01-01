const String tableCart = 'cart';

class CartFields {
  static const List<String> values = [
    id,
    title,
    price,
    imageUrl,
    count,
    countInStock,
    storeID,
    storeName,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String price = 'price';
  static const String imageUrl = 'imageUrl';
  static const String count = 'count';
  static const String countInStock = 'countInStock';
  static const String storeID = "storeID";
  static const String storeName = "storeName";
}

class CartItem {
  String id;
  String title;
  int price;
  String imageUrl;
  int count;
  int countInStock;
  String storeID;
  String storeName;

  CartItem(
    this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.count,
    this.countInStock,
    this.storeID,
    this.storeName,
  );

  Map<String, Object?> toJson() => {
        CartFields.id: id,
        CartFields.title: title,
        CartFields.price: price,
        CartFields.imageUrl: imageUrl,
        CartFields.count: count,
        CartFields.countInStock: countInStock,
        CartFields.storeID: storeID,
        CartFields.storeName: storeName,
      };

  static CartItem fromJson(Map<String, Object?> json) => CartItem(
        json[CartFields.id] as String,
        json[CartFields.title] as String,
        json[CartFields.price] as int,
        json[CartFields.imageUrl] as String,
        json[CartFields.count] as int,
        json[CartFields.countInStock] as int,
        json[CartFields.storeID] as String,
        json[CartFields.storeName] as String,
      );
}
