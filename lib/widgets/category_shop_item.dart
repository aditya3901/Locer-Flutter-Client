import 'package:flutter/material.dart';
import 'package:locer/utils/models/child_model.dart';
import 'package:locer/utils/models/store_model.dart';
import 'package:locer/widgets/product_item.dart';

class CategoryShopItem extends StatelessWidget {
  const CategoryShopItem(
    this.store,
    this.items,
  );

  final StoreModel store;
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  width: 50,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                    "assets/images/driver.png",
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  placeholder: const AssetImage("assets/images/driver.png"),
                  image: NetworkImage(store.imageUrl),
                ),
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
                      store.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      store.description,
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
