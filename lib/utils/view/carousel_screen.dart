import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sportspark/utils/const/const.dart';

class HomeCarouselScreen extends StatefulWidget {
  const HomeCarouselScreen({super.key});

  @override
  State<HomeCarouselScreen> createState() => _HomeCarouselScreenState();
}

class _HomeCarouselScreenState extends State<HomeCarouselScreen> {
  final List<String> _imagePaths = [
    'assets/basketball.jpg',
    'assets/cricket truf.jpg',
    'assets/kabadi.jpg',
    'assets/karate.jpg',
    'assets/skating.jpg',
    'assets/volleyball.jpg',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sports Gallery"),
        backgroundColor: AppColors.iconColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 300,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
            items: _imagePaths.map((imagePath) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _imagePaths.asMap().entries.map((entry) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? AppColors.iconColor
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
