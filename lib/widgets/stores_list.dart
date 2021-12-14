import 'package:flutter/material.dart';
import 'package:locer/screens/shop_screen.dart';

class StoresList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget storeItem(String title, String subtitle, String image) {
      return ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            ShopScreen.routeName,
            arguments: {
              "title": title,
              "image": image,
            },
          );
        },
        leading: ClipRRect(
          child: Image.network(
            image,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
        ),
      );
    }

    return Container(
      height: 300,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          storeItem("Spencer's", "All in one supermarket",
              "https://companycontactinformation.com/wp-content/uploads/2020/09/SPENCERS.png"),
          storeItem("7-Eleven", "All in one supermarket",
              "https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/7-eleven_logo.svg/2110px-7-eleven_logo.svg.png"),
          storeItem("Spencer's", "All in one supermarket",
              "https://companycontactinformation.com/wp-content/uploads/2020/09/SPENCERS.png"),
          storeItem("7-Eleven", "All in one supermarket",
              "https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/7-eleven_logo.svg/2110px-7-eleven_logo.svg.png"),
        ],
      ),
    );
  }
}
