import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqflitePage extends StatefulWidget {
  SqflitePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _SqflitePageState();
}

class _SqflitePageState extends State<SqflitePage> {
  final todos = <Todo>[];

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
        floatingActionButton: new Row(
          children: <Widget>[
            new FloatingActionButton(
              onPressed: () {
                getDatabasesPath().then((databasePath) async {
                  String path = join(databasePath, "$tableTodo.db");
                  var provider = new TodoProvider();
                  await provider.open(path);
                  await provider.insertBatch([
                    new Todo.fromMap({
                      columnId: null,
                      columnTitle: "todo1",
                      columnDone: 0,
                    }),
                    new Todo.fromMap({
                      columnId: null,
                      columnTitle: "todo2",
                      columnDone: 0,
                    }),
                    new Todo.fromMap({
                      columnId: null,
                      columnTitle: "todo3",
                      columnDone: 0,
                    }),
                  ]);
                  await provider.close();
                });
              },
              heroTag: "image0",
              child: const Icon(Icons.add),
            ),
            new FloatingActionButton(
              onPressed: () {
                getDatabasesPath().then((databasePath) async {
                  String path = join(databasePath, "$tableTodo.db");
                  var provider = new TodoProvider();
                  await provider.open(path);
                  var list = await provider.getAll();
                  if (null != list) {
                    setState(() {
                      todos.clear();
                      todos.addAll(list);
                    });
                  }
                  await provider.close();
                });
              },
              heroTag: "image1",
              child: const Icon(Icons.search),
            ),
            new FloatingActionButton(
              onPressed: () {
                getDatabasesPath().then((databasePath) async {
                  String path = join(databasePath, "$tableTodo.db");
                  var provider = new TodoProvider();
                  await provider.open(path);
                  var removeLast;
                  setState(() {
                    removeLast = todos.removeLast();
                  });
                  var count = await provider.delete(removeLast.id);
                  print("deleted count = $count");
                  await provider.close();
                });
              },
              heroTag: "image2",
              child: const Icon(Icons.delete),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        body: new ListView.builder(
          itemBuilder: (context, index) {
            return new ListTile(
              title: new Text(todos[index].title),
              subtitle: new Text(
                  'id = ${todos[index].id}, finished? ${todos[index].done ==
                      1}'),
            );
          },
          itemCount: todos.length,
        ),
      );

  void initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'demo.db');

    await deleteDatabase(path);

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, "
          "name TEXT, value INTEGER,num REAL)");
    });

    await database.transaction((trans) async {
      int id1 = await trans.rawInsert(
          'INSERT INTO Test(name,value,num) VALUES("some name", 1234, 456.789)');
      print("inserted1: $id1");
      int id2 = await trans.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?,?,?)',
          ["another name", 12345678, 3.1416]);
      print("inserted2: $id2");
      trans.batch();
    });

    int count = await database.rawUpdate(
        'UPDATE Test SET name=?, VALUE =? '
        'WHERE name =?',
        ["updated name", "9876", "some name"]);
    print("updated: $count");

    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    List<Map> expectedList = [
      {"name": "updated name", "id": 1, "value": 9876, "num": 456.789},
      {"name": "another name", "id": 2, "value": 12345678, "num": 3.1416}
    ];
    print(list);
    print(expectedList);
    assert(const DeepCollectionEquality().equals(list, expectedList));

    count = Sqflite
        .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
    assert(count == 2);

    count = await database
        .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
    assert(count == 1);
    await database.close();
  }
}

final String tableTodo = "todo";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDone = "done";

class Todo {
  int id;
  String title;
  bool done;

  Map<String, dynamic> toMap() {
    Map map = <String, dynamic>{columnTitle: title, columnDone: done ? 1 : 0};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''create table $tableTodo($columnId integer 
          primary key autoincrement, $columnTitle text not null,
          $columnDone integer not null)''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> getAll() async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],);
    var list = <Todo>[];
    maps.forEach((element){
      list.add(new Todo.fromMap(element));
    });
    return list;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();

  Future insertBatch(List<Todo> list) async {
    Batch batch = db.batch();
    list.forEach((todo) {
      batch.insert(tableTodo, todo.toMap());
    });
    await batch.commit(noResult: true);
  }
}
