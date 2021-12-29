const String tableCart = 'cart';

class CartFields {
  static const List<String> values = [
    id,
    title,
    price,
    imageUrl,
    count,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String price = 'price';
  static const String imageUrl = 'imageUrl';
  static const String count = 'count';
}

class CartItem {
  String id;
  String title;
  int price;
  String imageUrl;
  int count;

  CartItem(this.id, this.title, this.price, this.imageUrl, this.count);

  Map<String, Object?> toJson() => {
        CartFields.id: id,
        CartFields.title: title,
        CartFields.price: price,
        CartFields.imageUrl: imageUrl,
        CartFields.count: count,
      };

  static CartItem fromJson(Map<String, Object?> json) => CartItem(
        json[CartFields.id] as String,
        json[CartFields.title] as String,
        json[CartFields.price] as int,
        json[CartFields.imageUrl] as String,
        json[CartFields.count] as int,
      );
}
