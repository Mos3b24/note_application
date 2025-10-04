import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'note_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  final List<String> images = [
    'https://img.freepik.com/premium-vector/post-it-notes-icon-vector-design-template-simple-clean_1309366-535.jpg',
    'https://img.freepik.com/premium-vector/sticky-note-icon-vector-design-template-simple-clean_1309366-3100.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz_3St74pzUoySVLkLlxRKFFtc8ggmrSGFMQ&s',
  ];

  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController(); // Fixed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF030920),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 50,),

          Row(
            children: [
              Text(
                context.locale.languageCode == 'en' ? "EN" : "AR",
                style: const TextStyle(fontSize: 16),
              ),
              Switch(
                value: context.locale.languageCode == 'ar',
                onChanged: (value) {
                  if (value) {
                    context.setLocale(const Locale('ar'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                    setState(() {}); // refresh text + switch
                },
              ),
            ],
          ),
                
          Expanded(
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: images.length,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(images[index]),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 350,
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                Text(
                  'description'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'description_2'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.asMap().entries.map((entry) {
                    return Container(
                      width: 9,
                      height: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key
                            ? Colors.blueAccent
                            : Colors.grey[300],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex < images.length - 1) {
                      _carouselController.nextPage(
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotePage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF061a55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Text(
                    'next'.tr(),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}