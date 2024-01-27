import 'package:fav_places_app/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationSelector extends StatefulWidget {
  const LocationSelector(
      {super.key, required this.pickLocation, required this.pickAddress,required this.address});

  final void Function(String) pickLocation;
  final void Function(String) pickAddress;

  final String? address;

  @override
  State<LocationSelector> createState() {
    return _LocationSelectorState();
  }
}

class _LocationSelectorState extends State<LocationSelector> {
  late LocationData _currentLocation;

  Future<void> _getLocationData() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    _currentLocation=locationData;

  }



  bool _isGettingLocation = false;
  var locationUrl;
  bool _isCorrectLocation = false;

  void _getLocation() async {
    String address;
    Navigator.pop(context);
    setState(() {
      _isCorrectLocation = false;
      _isGettingLocation = true;
    });

    await _getLocationData();

    setState(() {
      locationUrl =
          "https://www.google.com/maps?q=${_currentLocation.latitude},${_currentLocation.longitude}";
      _isGettingLocation = false;
    });

    if (!context.mounted) {
      return;
    }

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        _currentLocation.latitude!, _currentLocation.longitude!);
    if (placemarks.isNotEmpty) {
      geo.Placemark placemark = placemarks[0];

        address =
            "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}";
      setState(() {
        _isCorrectLocation = true;
      });

      widget.pickLocation(locationUrl);
      widget.pickAddress(address);
    }
  }

  void _showDialogBox() {
    showDialog(
        context: context,
        builder: (ctx) {
          return Center(
            child: Container(
              width: 450,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ThemeData().colorScheme.secondary),
              margin: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _getLocation,
                    icon: const Icon(
                      Icons.maps_ugc_outlined,
                      size: 35,
                    ),
                    label: const Text(
                      'Get current location',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() {
                        _isGettingLocation=true;
                        _isCorrectLocation=false;
                      });
                      await _getLocationData();
                      setState(() {
                        _isGettingLocation=false;
                      });
                      if(!context.mounted){
                        return;
                      }
                      await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return MapScreen(locationData: _currentLocation,pickAddress: widget.pickAddress,pickLocation: widget.pickLocation,);
                      }));

                      setState(() {
                        _isCorrectLocation=true;
                      });
                    },
                    icon: const Icon(
                      Icons.map_rounded,
                      size: 35,
                    ),
                    label: const Text(
                      "Select on map",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(context) {
    Widget content = Center(
      child: TextButton.icon(
        onPressed: _showDialogBox,
        icon: const Icon(
          Icons.location_on_outlined,
          size: 30,
        ),
        label: const Text(
          'Click to add location',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );

    if (_isGettingLocation) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isCorrectLocation) {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            widget.address!,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Color(0xFDBCA7EE), fontSize: 20),
          ),
        ),
      );
    }

    return Container(
      height: 250,
      width: 250,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: GestureDetector(
        onTap: _showDialogBox,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ThemeData().colorScheme.secondary),
          width: 220,
          height: 220,
          clipBehavior: Clip.hardEdge,
          child: content,
        ),
      ),
    );
  }
}
