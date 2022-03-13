import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locer/providers/theme_provider.dart';
import '../screens/screens.dart';
import 'package:locer/utils/networking.dart';
import '../utils/models/models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString("location_pin") ?? "841301";
    String url = "https://locerappdemo.herokuapp.com/api/stores/location/$pin";
    NetworkHelper helper = NetworkHelper(url);
    var data = await helper.getData();
    if (data != null) {
      for (var item in data) {
        var store = StoreModel(
          item["name"],
          item["type"],
          "https://res.cloudinary.com/locer/image/upload/v1629819047/locer/products/${item["filename"]}",
        );
        list.add(store);
      }
      // If no stores are present at given PINCODE
      if (list.isEmpty) {
        list.add(StoreModel("NA", "NA", "NA"));
      }
      if (mounted) {
        setState(() {});
      }
    }
    // If response from API is not valid
    else {
      if (list.isEmpty) {
        list.add(StoreModel("NA", "NA", "NA"));
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget storeItem(String title, String subtitle, String image, int index) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return ShopScreen(title, index);
          }));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(
                    top: 4, bottom: 4, left: 15, right: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    width: 56,
                    height: 56,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                      "assets/images/driver.png",
                      width: 56,
                      fit: BoxFit.contain,
                    ),
                    placeholder: const AssetImage("assets/images/driver.png"),
                    image: NetworkImage(image),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(subtitle, maxLines: 1),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward,
                  color: Provider.of<ThemeProvider>(context).darkTheme
                      ? Colors.white
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      child: (list.isEmpty)
          ? Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CupertinoActivityIndicator(
                    radius: 15,
                  ),
                  SizedBox(height: 20),
                  Text("Restart the app if it takes too long"),
                ],
              ),
            )
          : (list[0].title == "NA")
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "We regret to inform you that we are not yet operating at your location. We are currently operating at Chhapra, Bihar(841301) Hopefully we will see you soon.",
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
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
