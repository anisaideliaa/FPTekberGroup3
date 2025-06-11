import 'package:flutter/material.dart';

class MapSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Map Section Placeholder',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}
