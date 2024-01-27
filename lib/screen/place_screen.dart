import 'package:fav_places_app/screen/location_screen.dart';
import 'package:flutter/material.dart';

import '../model/place_model.dart';

class PlaceScreen extends StatelessWidget {
  const PlaceScreen({super.key, required this.placeItem});

  final Place placeItem;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeItem.name),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(20),
              height: 600,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.file(
                  placeItem.placeImage,
                  fit: BoxFit.fill,
                ),
              )),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                return LocationScreen(locationUrl: placeItem.locationUrl);
              }));
            },
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin:
                      const EdgeInsets.only(bottom: 35, left: 35, right: 35),
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: ThemeData().colorScheme.tertiary,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        foregroundImage: const AssetImage(
                            'assets/images/location-162102_1280.webp'),
                        backgroundColor: ThemeData().colorScheme.tertiary,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 150,
                        ),
                        child: Text(
                          placeItem.address,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
