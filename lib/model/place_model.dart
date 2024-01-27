import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid=Uuid();
class Place{

  Place({required this.name,required this.placeImage,required this.locationUrl,required this.address,id}) : id=id ?? uuid.v4();

  final String name;
  final String id;
  final File placeImage;
  final String locationUrl;
  final String address;
}