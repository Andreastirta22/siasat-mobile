import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PickVenueLocationPage extends StatefulWidget {
  const PickVenueLocationPage({super.key});

  @override
  State<PickVenueLocationPage> createState() => _PickVenueLocationPageState();
}

class _PickVenueLocationPageState extends State<PickVenueLocationPage> {
  final MapController mapController = MapController();

  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  List<dynamic> suggestions = [];

  LatLng selectedLatLng = const LatLng(-6.200000, 106.816666);

  String? selectedAddress;

  bool isSearching = false;

  /// =========================
  /// SEARCH LOCATION
  /// =========================
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });

      return;
    }

    setState(() {
      isSearching = true;
    });

    final url =
        'https://nominatim.openstreetmap.org/search'
        '?q=$query'
        '&format=json'
        '&addressdetails=1'
        '&limit=5';

    try {
      final response = await http.get(
        Uri.parse(url),

        headers: {'User-Agent': 'CrewSync App'},
      );

      if (response.statusCode == 200) {
        setState(() {
          suggestions = jsonDecode(response.body);

          isSearching = false;
        });
      } else {
        setState(() {
          suggestions = [];
          isSearching = false;
        });
      }
    } catch (e) {
      setState(() {
        suggestions = [];
        isSearching = false;
      });
    }
  }

  /// =========================
  /// DEBOUNCE SEARCH
  /// =========================
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchLocation(value);
    });
  }

  /// =========================
  /// SELECT LOCATION
  /// =========================
  void selectLocation(dynamic item) {
    final lat = double.parse(item['lat']);
    final lon = double.parse(item['lon']);

    final latLng = LatLng(lat, lon);

    setState(() {
      selectedLatLng = latLng;

      selectedAddress = item['display_name'];

      suggestions = [];

      searchController.text = item['display_name'];
    });

    mapController.move(latLng, 16);
  }

  /// =========================
  /// CONFIRM LOCATION
  /// =========================
  void confirmLocation() {
    Navigator.pop(context, {
      "latitude": selectedLatLng.latitude,

      "longitude": selectedLatLng.longitude,

      "address": selectedAddress ?? '',

      "name": searchController.text,
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),

      child: Scaffold(
        extendBodyBehindAppBar: true,

        resizeToAvoidBottomInset: true,

        appBar: AppBar(
          elevation: 0,

          backgroundColor: Colors.black.withOpacity(0.35),

          iconTheme: const IconThemeData(color: Colors.white),

          title: const Text(
            'Pick Venue Location',

            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        body: Stack(
          children: [
            /// =========================
            /// MAP
            /// =========================
            FlutterMap(
              mapController: mapController,

              options: MapOptions(
                initialCenter: selectedLatLng,

                initialZoom: 13,

                onTap: (tapPosition, point) {
                  FocusScope.of(context).unfocus();

                  setState(() {
                    selectedLatLng = point;

                    selectedAddress = null;
                  });
                },
              ),

              children: [
                TileLayer(
                  urlTemplate:
                      'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',

                  userAgentPackageName: 'com.example.crewsync_mobile',
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLatLng,

                      width: 50,
                      height: 50,

                      child: const Icon(
                        Icons.location_pin,

                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// =========================
            /// SEARCH BOX
            /// =========================
            Positioned(
              top: 110,
              left: 16,
              right: 16,

              child: Column(
                children: [
                  Material(
                    elevation: 6,

                    borderRadius: BorderRadius.circular(18),

                    child: TextField(
                      controller: searchController,

                      onChanged: onSearchChanged,

                      style: const TextStyle(color: Colors.black, fontSize: 16),

                      cursorColor: Colors.black,

                      decoration: InputDecoration(
                        hintText: 'Search location...',

                        hintStyle: TextStyle(color: Colors.grey.shade600),

                        prefixIcon: Icon(
                          Icons.search,

                          color: Colors.grey.shade700,
                        ),

                        filled: true,

                        fillColor: Colors.white,

                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),

                          borderSide: const BorderSide(
                            color: Colors.blueAccent,

                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// =========================
                  /// SUGGESTIONS
                  /// =========================
                  if (suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 10),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(18),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),

                            blurRadius: 12,
                          ),
                        ],
                      ),

                      child: ListView.separated(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: suggestions.length,

                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey.shade200),

                        itemBuilder: (context, index) {
                          final item = suggestions[index];

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,

                              vertical: 6,
                            ),

                            leading: const Icon(
                              Icons.location_on_outlined,

                              color: Colors.blueAccent,
                            ),

                            title: Text(
                              item['display_name'],

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                color: Colors.black,

                                fontSize: 14,
                              ),
                            ),

                            onTap: () => selectLocation(item),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            /// =========================
            /// CONFIRM BUTTON
            /// =========================
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,

              child: SizedBox(
                height: 56,

                child: ElevatedButton(
                  onPressed: confirmLocation,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: const Text(
                    'Use This Location',

                    style: TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.bold,

                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
