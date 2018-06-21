import 'package:flutter/material.dart';

class ListViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ListViewState();
}

class _ListViewState extends State<ListViewPage> {
  List _widgets = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      _widgets.add(getRow(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ListView Sample'),
      ),
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _widgets[index];
        },
        itemCount: _widgets.length,
      ),
    );
  }

  getRow(int i) => new GestureDetector(
        child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Text('Row $i'),
        ),
        onTap: () {
          setState(() {
            _widgets.add(getRow(_widgets.length + 1));
            print('row $i');
          });
        },
      );
}
