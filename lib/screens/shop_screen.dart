import 'package:flutter/material.dart';
import 'package:locer/widgets/product_item.dart';

class ShopScreen extends StatelessWidget {
  static const routeName = "/shop-screen";

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    final title = arg["title"];

    final item_list = [
      {
        "type": "Dairy & Bakery",
        "items": [
          {
            "image":
                "https://i1.fnp.com/images/pr/l/v20200707214941/chocolate-fudge-cake-half-kg_1.jpg",
            "price": 48.52,
            "title": "Cheese & Ghee",
          },
          {
            "image":
                "https://i1.fnp.com/images/pr/l/v20200707214941/chocolate-fudge-cake-half-kg_1.jpg",
            "price": 48.52,
            "title": "Birthday Cake",
          },
          {
            "image":
                "https://i1.fnp.com/images/pr/l/v20200707214941/chocolate-fudge-cake-half-kg_1.jpg",
            "price": 48.52,
            "title": "Ice Cream & Desserts",
          },
        ],
      },
      {
        "type": "Snacks & Branded Foods",
        "items": [
          {
            "image":
                "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg",
            "price": 48.52,
            "title": "Chocolate Chip Cookie",
          },
          {
            "image":
                "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg",
            "price": 48.52,
            "title": "Chocolate Chip Cookie",
          },
          {
            "image":
                "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg",
            "price": 48.52,
            "title": "Chocolate Chip Cookie",
          },
        ],
      },
      {
        "type": "Staples",
        "items": [
          {
            "image":
                "https://www.thespruceeats.com/thmb/I_M3fmEbCeNceaPrOP5_xNZ2xko=/3160x2107/filters:fill(auto,1)/vegan-tofu-tikka-masala-recipe-3378484-hero-01-d676687a7b0a4640a55be669cba73095.jpg",
            "price": 48.52,
            "title": "Atta, Flour & Sooji",
          },
          {
            "image":
                "https://www.thespruceeats.com/thmb/I_M3fmEbCeNceaPrOP5_xNZ2xko=/3160x2107/filters:fill(auto,1)/vegan-tofu-tikka-masala-recipe-3378484-hero-01-d676687a7b0a4640a55be669cba73095.jpg",
            "price": 48.52,
            "title": "Dals & Pulses",
          },
          {
            "image":
                "https://www.thespruceeats.com/thmb/I_M3fmEbCeNceaPrOP5_xNZ2xko=/3160x2107/filters:fill(auto,1)/vegan-tofu-tikka-masala-recipe-3378484-hero-01-d676687a7b0a4640a55be669cba73095.jpg",
            "price": 48.52,
            "title": "Rice & Rice Products",
          },
        ],
      },
      {
        "type": "Snacks & Branded Foods",
        "items": [
          {
            "image":
                "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg",
            "price": 48.52,
            "title": "Chocolate Chip Cookie",
          },
          {
            "image":
                "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg",
            "price": 48.52,
            "title": "Chocolate Chip Cookie",
          },
          {
            "image":
                "https://images-gmi-pmc.edge-generalmills.com/087d17eb-500e-4b26-abd1-4f9ffa96a2c6.jpg",
            "price": 48.52,
            "title": "Chocolate Chip Cookie",
          },
        ],
      },
      {
        "type": "Dairy & Bakery",
        "items": [
          {
            "image":
                "https://i1.fnp.com/images/pr/l/v20200707214941/chocolate-fudge-cake-half-kg_1.jpg",
            "price": 48.52,
            "title": "Cheese & Ghee",
          },
          {
            "image":
                "https://i1.fnp.com/images/pr/l/v20200707214941/chocolate-fudge-cake-half-kg_1.jpg",
            "price": 48.52,
            "title": "Birthday Cake",
          },
          {
            "image":
                "https://i1.fnp.com/images/pr/l/v20200707214941/chocolate-fudge-cake-half-kg_1.jpg",
            "price": 48.52,
            "title": "Ice Cream & Desserts",
          },
        ],
      },
      {
        "type": "Staples",
        "items": [
          {
            "image":
                "https://www.thespruceeats.com/thmb/I_M3fmEbCeNceaPrOP5_xNZ2xko=/3160x2107/filters:fill(auto,1)/vegan-tofu-tikka-masala-recipe-3378484-hero-01-d676687a7b0a4640a55be669cba73095.jpg",
            "price": 48.52,
            "title": "Atta, Flour & Sooji",
          },
          {
            "image":
                "https://www.thespruceeats.com/thmb/I_M3fmEbCeNceaPrOP5_xNZ2xko=/3160x2107/filters:fill(auto,1)/vegan-tofu-tikka-masala-recipe-3378484-hero-01-d676687a7b0a4640a55be669cba73095.jpg",
            "price": 48.52,
            "title": "Dals & Pulses",
          },
          {
            "image":
                "https://www.thespruceeats.com/thmb/I_M3fmEbCeNceaPrOP5_xNZ2xko=/3160x2107/filters:fill(auto,1)/vegan-tofu-tikka-masala-recipe-3378484-hero-01-d676687a7b0a4640a55be669cba73095.jpg",
            "price": 48.52,
            "title": "Rice & Rice Products",
          },
        ],
      },
    ];

    Widget shopItem(String cat, List<Map<String, Object>> items) {
      return Column(
        children: [
          // Category Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Text(
                    cat,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      wordSpacing: -1,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Text(
                  "View more >",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return shopItem(
              item_list[index]["type"] as String,
              item_list[index]["items"] as List<Map<String, Object>>,
            );
          },
          itemCount: item_list.length,
        ),
      ),
    );
  }
}
