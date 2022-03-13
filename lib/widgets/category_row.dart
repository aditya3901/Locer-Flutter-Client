import 'package:flutter/material.dart';
import '../screens/screens.dart';

class CategoryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          CategoryItem(
            title: "Drinks",
            icon: Icons.emoji_food_beverage,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return BeveragesScreen();
              }));
            },
          ),
          CategoryItem(
            title: "Staples",
            icon: Icons.grain,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return StaplesScreen();
              }));
            },
          ),
          CategoryItem(
            title: "Snacks",
            icon: Icons.fastfood,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return SnacksScreen();
              }));
            },
          ),
          CategoryItem(
            title: "Hygiene",
            icon: Icons.air,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return PersonalCareScreen();
              }));
            },
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const CategoryItem(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Icon(
            icon,
            color: Colors.green,
            size: 35,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
