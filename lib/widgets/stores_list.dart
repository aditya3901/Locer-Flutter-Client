import 'package:flutter/material.dart';
import 'package:locer/screens/shop_screen.dart';
import 'package:locer/utils/networking.dart';
import 'package:locer/utils/store_model.dart';

const String url =
    "https://locerappdemo.herokuapp.com/api/stores/location/841301";

class StoresList extends StatefulWidget {
  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  List<StoreModel> list = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    NetworkHelper helper = NetworkHelper(url);
    var data = await helper.getData();
    if (data != null) {
      for (var item in data) {
        var store = StoreModel(
          item["name"],
          item["type"],
          "https://companycontactinformation.com/wp-content/uploads/2020/09/SPENCERS.png",
        );
        list.add(store);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget storeItem(String title, String subtitle, String image, int index) {
      return ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            ShopScreen.routeName,
            arguments: {
              "title": title,
              "index": index,
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

    return SizedBox(
      height: 300,
      child: (list.isEmpty)
          ? Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [CircularProgressIndicator()],
              ),
          )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                return storeItem(
                  list[index].title,
                  list[index].description,
                  list[index].imageUrl,
                  index,
                );
              },
              itemCount: list.length,
            ),
    );
  }
}
