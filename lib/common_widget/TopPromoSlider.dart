import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TopPromoSlider extends StatelessWidget {
  final List<String> imageUrls = [
    "https://www.nynyduelingpianos.com/wp-content/uploads/2017/04/piano-banner-1.png",
    "https://i.redd.it/1m1dtflo6rb11.png",
  ];

  TopPromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        height: 200.0,
        width: double.infinity,
        child: CarouselSlider(
          items: imageUrls.map((imageUrl) {
            return Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          }).toList(),
          options: CarouselOptions(
            height: 150.0,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            // Other options go here
          ),
        ),
      ),
    );
  }
}
