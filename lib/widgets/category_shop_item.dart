import 'package:flutter/material.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/widgets/product_item.dart';

class CategoryShopItem extends StatelessWidget {
  const CategoryShopItem(
    this.catTitle,
    this.items,
  );

  final String catTitle;
  final List<ChildModel> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category Name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.5,
                  color: Colors.black54,
                ),
              ),
              margin: const EdgeInsets.only(top: 8, left: 8),
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                "assets/images/driver.png",
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Kirana & General Store",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Product Item List
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              return ProductItem(items[index]);
            },
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}
