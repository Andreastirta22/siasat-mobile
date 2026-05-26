import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PickVenueLocationPage extends StatefulWidget {
  const PickVenueLocationPage({super.key});

  @override
  State<PickVenueLocationPage> createState() => _PickVenueLocationPageState();
}

class _PickVenueLocationPageState extends State<PickVenueLocationPage> {
  LatLng selectedLocation = const LatLng(-6.265457, 106.784912);

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
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
            /// =======================
            /// MAP
            /// =======================
            FlutterMap(
              options: MapOptions(
                initialCenter: selectedLocation,
                initialZoom: 16,

                onTap: (tapPosition, point) {
                  FocusScope.of(context).unfocus();

                  setState(() {
                    selectedLocation = point;
                  });
                },
              ),

              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                  userAgentPackageName: 'com.example.crewsync_mobile',
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation,

                      width: 80,
                      height: 80,

                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 42,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// =======================
            /// SEARCH FIELD
            /// =======================
            Positioned(
              top: 110,
              left: 20,
              right: 20,

              child: Material(
                elevation: 6,

                borderRadius: BorderRadius.circular(18),

                child: TextField(
                  controller: searchController,

                  style: const TextStyle(color: Colors.black, fontSize: 16),

                  cursorColor: Colors.black,

                  decoration: InputDecoration(
                    hintText: 'Search location...',

                    hintStyle: TextStyle(color: Colors.grey.shade600),

                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),

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
            ),

            /// =======================
            /// BOTTOM CARD
            /// =======================
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,

              child: Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 14,

                      color: Colors.black.withOpacity(0.15),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Selected Coordinate',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Latitude: ${selectedLocation.latitude}',

                      style: const TextStyle(color: Colors.black87),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Longitude: ${selectedLocation.longitude}',

                      style: const TextStyle(color: Colors.black87),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            'latitude': selectedLocation.latitude,

                            'longitude': selectedLocation.longitude,
                          });
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        child: const Text(
                          'Use This Location',

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
