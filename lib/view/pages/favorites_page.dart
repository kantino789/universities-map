import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:universities_map/model/editor.dart';
import 'package:universities_map/model/poi.dart';
import 'package:universities_map/view/favorites_page/poi_favorite_icon.dart';
import 'package:universities_map/view/markers/poi_details.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _showPoiDetails(BuildContext context, Poi poi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return PoiDetails(poi: poi);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final editor = StringPropertyChangeProvider.of<Editor, String>(
      context,
      properties: [Editor.poisFavoriteChanged],
    )!.value;
    final favoritePois = editor.favoritePois.toList();
    favoritePois.sort((a, b) => a.title.compareTo(b.title));
    return favoritePois.isEmpty
        ? const Center(child: Text('No favorites yet.'))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: favoritePois.length,
              itemBuilder: (context, index) {
                final poi = favoritePois.elementAt(index);
                return Card(
                  child: ListTile(
                    onTap: () => _showPoiDetails(context, poi),
                    leading: Flag.fromString(
                      poi.country,
                      width: 24,
                      height: 24,
                    ),
                    title: Text(poi.title),
                    trailing: PoiFavoriteIcon(poi: poi),
                  ),
                );
              },
            ),
          );
  }
}
