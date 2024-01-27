import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/place_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class FavPlaceNotifier extends StateNotifier<List<Place>>{
  
  Future<void> loadData() async {
    final dbPath = await sql.getDatabasesPath();
    final dataBase = await sql.openDatabase(
      path.join(dbPath, 'Places.db'),
      onCreate: (db, version){
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, placeImage TEXT, locationUrl TEXT, address TEXT)');
      },
      version: 1,
    );
    final data = await dataBase.query('user_places');
    final places = data.map((element){
      return Place(id: element['id'], name: element['name'] as String, placeImage: File(element['placeImage'] as String), locationUrl: element['locationUrl'] as String, address: element['address'] as String);
    }).toList();

    state = places;
    await dataBase.close();
  }

  Future<void> deletePlace(Place item) async {
    final dbPath = await sql.getDatabasesPath();
    final database = await sql.openDatabase(
      path.join(dbPath, 'Places.db'),
      onCreate: (db, version){
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, placeImage TEXT, locationUrl TEXT, address TEXT)');
      },
      version: 1,
    );

    await database.delete(
      'user_places',
      where: 'id = ?', // Adjust the condition based on your schema
      whereArgs: [item.id], // Adjust the arguments based on your schema
    );

    await database.close();
  }

  FavPlaceNotifier():super([]);

  void togglePlace(Place item) async {
    if(state.contains(item)){

      state=state.where((element){
        if(element.name==item.name){
          return false;
        }
        else{
          return true;
        }
      }).toList();
    }
    else{
      final dbPath = await sql.getDatabasesPath();
      final dataBase = await sql.openDatabase(
        path.join(dbPath, 'Places.db'),
        onCreate: (db, version){
          return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, placeImage TEXT, locationUrl TEXT, address TEXT)');
        },
        version: 1,
      );

      dataBase.insert('user_places', {
        'id': item.id,
        'name': item.name,
        'placeImage': item.placeImage.path,
        'locationUrl': item.locationUrl,
        'address': item.address,
      });
      state=[...state,item];
      await dataBase.close();
    }
  }
}


final FavPlaceProvider=StateNotifierProvider<FavPlaceNotifier,List<Place>>((ref){

  return FavPlaceNotifier();
});

