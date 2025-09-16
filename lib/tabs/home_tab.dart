import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final List<String> promoImages = [
      'https://via.placeholder.com/600x250.png/F97700/FFFFFF?text=Special+Offer',
      'https://via.placeholder.com/600x250.png/333333/FFFFFF?text=New+Arrivals',
      'https://via.placeholder.com/600x250.png/F97700/FFFFFF?text=Combo+Deals',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promotional Banner
          CarouselSlider(
            options: CarouselOptions(
              height: 180.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.9,
            ),
            items: promoImages.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(i),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Categories Section
          _buildSectionHeader(context, 'Categories'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCategoryCard('Rounded Khakhra')),
              const SizedBox(width: 16),
              Expanded(child: _buildCategoryCard('Mobile Shape Khakhra')),
            ],
          ),
          const SizedBox(height: 24),

          // Best Sellers Section
          _buildSectionHeader(context, 'Best Sellers'),
          const SizedBox(height: 12),
          _buildProductCarousel(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryCard(String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 80,
        alignment: Alignment.center,
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildProductCarousel() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Placeholder count
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Methi Khakhra',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('₹99.00', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
