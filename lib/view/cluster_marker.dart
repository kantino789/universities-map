import 'package:flutter/material.dart';

class ClusterMarker extends StatelessWidget {
  final int count;

  const ClusterMarker({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    // Different visual sizes based on number
    // of markers in the cluster.

    final double size;

    if (count >= 100) {
      size = 64;
    } else if (count >= 50) {
      size = 58;
    } else {
      size = 52;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: Colors.blue,

          border: Border.all(color: Colors.white, width: 4),

          boxShadow: const [
            BoxShadow(blurRadius: 8, spreadRadius: 1, color: Colors.black26),
          ],
        ),

        child: Center(
          child: Text(
            '$count',

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
