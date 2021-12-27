import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:locer/widgets/category_row.dart';
import 'package:locer/widgets/stores_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;
  final urlImages = [
    "https://pbs.twimg.com/media/DfFB1BOUcAAR1op.png",
    "https://cdn.grabon.in/gograbon/images/web-images/uploads/1618575517942/food-coupons.jpg",
    "https://www.dineout.co.in/blog/wp-content/uploads/2018/10/WhatsApp-Image-2018-10-18-at-8.06.23-PM.jpeg",
    "https://www.shopickr.com/wp-content/uploads/2017/08/foodpanda-freedom-sale-independence-day-offers-2017.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Welcome User
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Text(
            "Hi, Raushan!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        // Categories
        CategoryRow(),
        // Carousel Slider
        const SizedBox(height: 16),
        Column(
          children: [
            CarouselSlider.builder(
              itemCount: urlImages.length,
              itemBuilder: (ctx, index, realIndex) {
                final image = urlImages[index];
                return buildImage(image, index);
              },
              options: CarouselOptions(
                height: 220,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 26),
            buildIndicator(),
          ],
        ),
        // Stores List
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 8,
          ),
          child: Text(
            "Your Stores",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        StoresList(),
      ],
    );
  }

  Widget buildImage(String image, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        image,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: urlImages.length,
        effect: const SwapEffect(
          dotHeight: 12.0,
          dotWidth: 12.0,
          activeDotColor: Colors.green,
          dotColor: Colors.black12,
        ),
      );
}
