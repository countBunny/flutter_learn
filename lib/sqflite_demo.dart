import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqflitePage extends StatefulWidget {
  SqflitePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _SqflitePageState();
}

class _SqflitePageState extends State<SqflitePage> {
  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text('Sqflite Demo'),
        ),
      );

  void initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'demo.db');

    await deleteDatabase(path);

    Database database = await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, "
          "name TEXT, value INTEGER,num REAL)");

        });

    await database.transaction((trans) async {
      int id1 = await trans.rawInsert('INSERT INTO Test(name,value,num) VALUES("some name", 1234, 456.789)');
      print("inserted1: $id1");
      int id2 = await trans.rawInsert('INSERT INTO Test(name, value, num) VALUES(?,?,?)',
          ["anthor name", 12345678, 3.1416]);
      print("inserted2: $id2");
    });

  }
}
