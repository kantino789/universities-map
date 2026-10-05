import 'package:flutter/material.dart';
import 'package:universities_map/model/poi.dart';

class PoiCard extends StatelessWidget {
  final Poi poi;
  final VoidCallback onClose;

  const PoiCard({super.key, required this.poi, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 40, color: Colors.red),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poi.title,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(poi.description),
                ],
              ),
            ),

            IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}
