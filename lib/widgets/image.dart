import 'package:flutter/material.dart';

import 'package:astronomy_picture_of_the_day_app/screens/on_tap.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OnTap(imageUrl: imageUrl),
            ),
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Hero(
                tag: 1,
                child: Image.network(
                  imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                  height: 600,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
