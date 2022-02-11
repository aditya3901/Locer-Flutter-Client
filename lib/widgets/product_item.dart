import 'package:flutter/material.dart';
import 'package:locer/screens/product_detail_screen.dart';
import 'package:locer/utils/db/products_database.dart';
import 'package:locer/utils/models/child_model.dart';

class ProductItem extends StatefulWidget {
  ChildModel item;
  ProductItem(this.item);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isFavourite = false;

  void _getData() async {
    ChildModel? item =
        await ProductsDatabase.instance.readProduct(widget.item.id);
    if (item != null) {
      setState(() {
        isFavourite = item.isFavourite;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(
        top: 8,
        left: 8,
        bottom: 4,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return ProductDetailScreen(widget.item);
            }));
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, left: 6, right: 6),
                      child: FadeInImage(
                        placeholder:
                            const AssetImage("assets/images/driver.png"),
                        image: NetworkImage(widget.item.imageUrl),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          "assets/images/driver.png",
                          height: 112,
                          fit: BoxFit.contain,
                        ),
                        fit: BoxFit.contain,
                        height: 112,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 6, left: 8, right: 8, bottom: 2),
                    child: Row(
                      children: [
                        Text(
                          "\u20B9${widget.item.discountedPrice}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "mrp. ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "\u20B9${widget.item.price}",
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      widget.item.title,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  iconSize: 22,
                  onPressed: () async {
                    if (isFavourite == false) {
                      isFavourite = true;
                      final item = ChildModel(
                        widget.item.countInStock,
                        widget.item.id,
                        widget.item.title,
                        widget.item.description,
                        widget.item.price,
                        widget.item.discountedPrice,
                        widget.item.imageUrl,
                        isFavourite,
                        widget.item.storeID,
                      );
                      await ProductsDatabase.instance.create(item);
                    } else if (isFavourite == true) {
                      isFavourite = false;
                      await ProductsDatabase.instance.delete(widget.item.id);
                    }
                    setState(() {});
                  },
                  icon: isFavourite
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Colors.green,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
