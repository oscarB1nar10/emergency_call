import 'package:flutter/material.dart';

class SubscriptionTile extends StatelessWidget {
  final String title; // e.g., "Premium Plan"
  final String description; // e.g., "Enjoy extra features..."
  final String price; // e.g., "\$4.99"
  final VoidCallback onTap; // Callback function for tap action

  const SubscriptionTile({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0), // spacing around the tile
        padding: const EdgeInsets.all(16.0), // spacing inside the tile
        decoration: BoxDecoration(
          color: Colors.white, // background color of the tile
          borderRadius: BorderRadius.circular(10.0), // rounded corner
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // shadow color
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0, // size of title
                fontWeight: FontWeight.bold, // thickness of the letters
                color: Colors.black, // color of title
              ),
            ),
            const SizedBox(height: 8.0),
            // spacing between title and description
            Text(
              description,
              style: TextStyle(
                fontSize: 16.0, // size of description
                color: Colors.grey[700], // color of description
              ),
            ),
            const SizedBox(height: 16.0),
            // spacing between description and price
            Text(
              price,
              style: TextStyle(
                fontSize: 24.0, // size of price
                fontWeight: FontWeight.bold, // thickness of the letters
                color: Colors.green[700], // color of price
              ),
            ),
          ],
        ),
      ),
    );
  }
}
