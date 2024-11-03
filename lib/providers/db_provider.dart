import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;

  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    print(path);

    //Crear base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE Scans(
      id INTEGER PRIMARY KEY,
      tipo TEXT,
      valor TEXT
      )
      ''');
    });
  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //Getter de la BD, que verifica la BD
    final db = await database;

    final res = await db!.rawInsert('''
    INSERT INTO Scans(id, tipo, valor)
    VALUES ( '$id', '$tipo' , '$valor' )
    ''');

    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db!.insert('Scans', nuevoScan.toJson());

    print("IMPRIMIR: $res");

    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    // Obtiene todos los registros (SELECT * from Scans)
    // final resAll = await db.query('Scans');
    // Obtiene el registro según un id
    final res = await db!.query('Scans', where: 'id = ?', whereArgs: [id]);

    // Obtiene el registro/s según varios parámetros
    //final resPorVarios = await db.query('Scans', where: 'id = ? and valor = ?',whereArgs: [id, valor]);
    // Si devuelve algún registro la consulta, lo pasamos a objeto Scan, sino null
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db!.query('Scans');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<ScanModel>> getScansByTipo(String tipo) async {
    final db = await database;

    // Aquí lo hacemos por el método raw, para probarlo
    final res = await db!.rawQuery('''
 SELECT * FROM Scans WHERE tipo = '$tipo'
 ''');
    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(ScanModel newScan) async {
    final db = await database;
    final res = await db!.update('Scans', newScan.toJson(),
        where: 'id = ?', whereArgs: [newScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db!.delete('Scans');
    return res;
  }
}
