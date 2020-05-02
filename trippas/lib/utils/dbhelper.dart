import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:trippas/models/trip.dart';


class DbHelper{
  DbHelper._internal();
  static final DbHelper dbHelper = DbHelper._internal();
  factory DbHelper(){
    return dbHelper;
  } 

  String tblTrip = 'trip';
  String colId = 'id';
  String colDeparture = 'departure';
  String colDepDate = 'depDate';
  String colDepTime = 'depTime';
  String colDestination = 'destination';
  String colDesDate = 'desDate';
  String colDesTime = 'desTime';
  String colTripType = 'tripType';

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $tblTrip($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDeparture TEXT, $colDepDate TEXT, $colDepTime TEXT, $colDestination TEXT, $colDesDate TEXT, $colDesTime TEXT, $colTripType TEXT)');
  }

  Future<Database> intializeDb() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'trips.db';
    var dbTrips = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTrips;
  }
   
  static Database _db;
  Future<Database> get db async{
    if(_db == null){
      _db = await intializeDb();
      return _db; 
    }
    return _db;
  }

  Future<int> insertTrip(Trip trip) async{
    Database db = await this.db;
    var result = await db.insert(tblTrip, trip.toMap());
    debugPrint('$result');
    return result;
  }

  Future<List> getTrips() async{
    Database db = await this.db;
    var result = await db.rawQuery('SELECT * FROM $tblTrip order by $colId DESC');
    return result;
  }

  Future<int> updateTrip(Trip trip) async {
    Database db = await this.db;
    var result = await db.update(tblTrip, trip.toMap(),where: '$colId = ?',whereArgs: [trip.id]);
    return result;
  }

  Future<int> countTrips() async {
    Database db = await this.db;
    int result =  Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT (*)FROM $tblTrip'));
    return result;
  }

  Future<int> deleteTrip(int id) async {
    Database db = await this.db;
    int result = await db.rawDelete('DELETE FROM $tblTrip where $colId = $id');
    return result;

  }
}