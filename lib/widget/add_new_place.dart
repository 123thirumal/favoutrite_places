import 'dart:io';
import 'package:fav_places_app/model/place_model.dart';
import 'package:fav_places_app/widget/image_select.dart';
import 'package:fav_places_app/widget/location_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fav_places_app/provider/placelist_provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() {
    return _AddPlaceState();
  }
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  File? _selectedImage;
  String? _selectedLocation;
  String? _selectedAddress;

  final _givenname = TextEditingController();

  void _pickLoaction(String loc){
    setState(() {
      _selectedLocation=loc;
    });
  }

  void _pickAddress(String add){
    setState(() {
      _selectedAddress=add;
    });
  }

  void _pickImage(File image){
    setState(() {
      _selectedImage=image;
    });
  }

  @override
  Widget build(context) {
    return SizedBox.expand(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextField(
                maxLength: 50,
                controller: _givenname,
                keyboardType: TextInputType.name,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  label: Text('Add Place'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ImageSelector(
                pickImage: _pickImage,
              ),
              const SizedBox(
                height: 20,
              ),
              LocationSelector(pickLocation: _pickLoaction,pickAddress: _pickAddress,address: _selectedAddress,),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: Navigator.of(context).pop,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF474B85)),
                    ),
                    child: const Text("cancel"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_givenname.text.trim().isEmpty ||
                          _selectedImage == null||_selectedLocation==null||_selectedAddress==null) {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                backgroundColor: ThemeData().colorScheme.secondary,
                                title: const Text('Complete all fields'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: Navigator.of(ctx).pop,
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            });
                      } else {
                        Navigator.pop(context);

                        final dir = await pathProvider.getApplicationDocumentsDirectory();
                        final filepath = path.basename(_selectedImage!.path);
                        final copiedImage = await _selectedImage!.copy('${dir.path}/$filepath');

                        ref.watch(FavPlaceProvider.notifier).togglePlace(Place(
                            name: _givenname.text.trim(),
                          placeImage: copiedImage,
                          locationUrl: _selectedLocation!,
                          address: _selectedAddress!,
                        ));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF474B85)),
                    ),
                    child: const Text("add"),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
