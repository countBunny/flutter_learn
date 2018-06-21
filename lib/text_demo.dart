import 'package:flutter/material.dart';

class TextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text('Text Demo'),
        ),
        body: new Center(
          child: new Text(
            'This is a custom font text',
            style: new TextStyle(fontFamily: 'fitzgerald'),
          ),
        ),
      );
}
