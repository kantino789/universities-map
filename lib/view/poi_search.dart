// import 'package:flutter/material.dart';
// import 'package:universities_map/model/poi.dart';

// class PoiSearch extends StatefulWidget {
//   final List<Poi> pois;
//   final ValueChanged<Poi> onSelected;

//   const PoiSearch({super.key, required this.pois, required this.onSelected});

//   @override
//   State<PoiSearch> createState() => _PoiSearchState();
// }

// class _PoiSearchState extends State<PoiSearch> {
//   final TextEditingController _controller = TextEditingController();

//   List<Poi> _results = [];

//   void _search(String query) {
//     final text = query.trim().toLowerCase();

//     if (text.isEmpty) {
//       setState(() {
//         _results = [];
//       });
//       return;
//     }

//     setState(() {
//       _results = widget.pois
//           .where((poi) => poi.title.toLowerCase().contains(text))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Material(
//           elevation: 4,
//           borderRadius: BorderRadius.circular(12),
//           child: TextField(
//             controller: _controller,
//             onChanged: _search,
//             decoration: InputDecoration(
//               hintText: 'Search locations...',
//               prefixIcon: const Icon(Icons.search),
//               suffixIcon: _controller.text.isNotEmpty
//                   ? IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         _controller.clear();
//                         _search('');
//                       },
//                     )
//                   : null,
//               filled: true,
//               fillColor: Colors.white,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),

//         if (_results.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 4),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _results.length,
//               itemBuilder: (context, index) {
//                 final poi = _results[index];

//                 return ListTile(
//                   leading: const Icon(Icons.location_on),
//                   title: Text(poi.title),
//                   subtitle: Text(poi.description),
//                   onTap: () {
//                     _controller.text = poi.title;

//                     setState(() {
//                       _results = [];
//                     });

//                     widget.onSelected(poi);
//                   },
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
