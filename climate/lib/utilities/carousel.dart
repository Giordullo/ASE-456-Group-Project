import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget makeCarousel(carouselObjs) {
  return CarouselSlider(
    items: carouselObjs,
    options: CarouselOptions(
        height: 250,
        aspectRatio: 16 / 9,
        viewportFraction: .6,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: true,
        autoPlay: false,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal),
  );
}
