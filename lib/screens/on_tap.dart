import 'dart:ui';

import 'package:flutter/material.dart';

class OnTap extends StatelessWidget {
  const OnTap({
    super.key,
    required this.imageUrl,
  });
  final String imageUrl;

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Stack(
          children: [
            Hero(
              tag: 1,
              child: InteractiveViewer(
                // boundaryMargin: const EdgeInsets.all(100.0),
                // minScale: .001,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fitWidth,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 50,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                tooltip: 'Back',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
