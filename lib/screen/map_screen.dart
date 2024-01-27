import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapScreen extends StatefulWidget {
  MapScreen(
      {super.key,
      required this.locationData,
      required this.pickAddress,
      required this.pickLocation});
  final void Function(String) pickLocation;
  final void Function(String) pickAddress;

  final LocationData locationData;

  late LatLng position;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    widget.position =
        LatLng(widget.locationData.latitude!, widget.locationData.longitude!);
  }

  void _pickPosition(LatLng pos) {
    setState(() {
      widget.position = pos;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your location'),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            //padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(15),
            height: 650,
            clipBehavior: Clip.hardEdge,
            child: FlutterMap(
              options: MapOptions(
                  initialCenter: widget.position,
                  initialZoom: 15.0,
                  onTap: (TapPosition tap, LatLng pos) {
                    _pickPosition(pos);
                  }),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.fav_places_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.position,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () {
                        launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright'));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              widget.pickLocation(
                  "https://www.google.com/maps?q=${widget.position.latitude},${widget.position.longitude}");
              List<geo.Placemark> placemarks =
                  await geo.placemarkFromCoordinates(
                      widget.position.latitude, widget.position.longitude);
              if (placemarks.isNotEmpty) {
                geo.Placemark placemark = placemarks[0];
                widget.pickAddress("${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}");
              }

              if(!context.mounted){
                return;
              }

              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF502D96)),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
