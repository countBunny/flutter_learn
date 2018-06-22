import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SharedPreferencesPage extends StatefulWidget {
  SharedPreferencesPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _SharedPreferencesState();
}

class _SharedPreferencesState extends State<SharedPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          onPressed: _incrementCounter,
          child: new Text('increment Counter'),
        ),
      ),
    );
  }

  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed ${count} times');
    await prefs.setInt('counter', count);
  }
}
