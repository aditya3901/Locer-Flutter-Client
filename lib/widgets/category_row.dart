import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        children: [
          CategoryItem(
            title: "Dairy",
            imageUrl: Icons.cake,
          ),
          CategoryItem(
            title: "Staples",
            imageUrl: Icons.grain,
          ),
          CategoryItem(
            title: "Snacks",
            imageUrl: Icons.fastfood,
          ),
          CategoryItem(
            title: "Beauty",
            imageUrl: Icons.air,
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData imageUrl;
  final String title;
  CategoryItem({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          title: Icon(
            imageUrl,
            color: Colors.green,
            size: 35,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
