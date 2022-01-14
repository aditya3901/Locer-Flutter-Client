import 'package:flutter/material.dart';
import 'package:locer/screens/product_detail_screen.dart';
import 'package:locer/utils/models/child_model.dart';

class ProductItem extends StatefulWidget {
  ChildModel item;
  ProductItem(this.item);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(
        top: 8,
        left: 8,
        bottom: 6,
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
          child: Column(
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
                    placeholder: const AssetImage("assets/images/driver.png"),
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
                padding:
                    const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                child: Text(
                  "\u20B9${widget.item.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
        ),
      ),
    );
  }
}
