import 'package:flutter/material.dart';

class LayoutDemoPage extends StatefulWidget {
  LayoutDemoPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _LayoutDemoState();
}

class _LayoutDemoState extends State<LayoutDemoPage> {
  static final GlobalKey<ScaffoldState> _mainKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget titleSection = new Padding(
        padding: EdgeInsets.all(32.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(
                      'Oeschinen Lake Campground',
                      style: textTheme.body2.copyWith(color: Colors.black87),
                    ),
                  ),
                  new Text(
                    'Kandersteg, Switzerland',
                    style: textTheme.body1.copyWith(color: Colors.grey[500]),
                  ),
                ])),
            new Icon(
              Icons.favorite,
              color: Colors.red[500],
            ),
            new Text('41',
                style: textTheme.body1.copyWith(color: Colors.black87))
          ],
        ));
    final buttonSection = new Padding(
      padding: EdgeInsets.all(5.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              _mainKey.currentState.showSnackBar(const SnackBar(
                  content: const Text("button 1 been clicked!")));
            },
            child: buildButtonColumn(Icons.phone, 'CALL'),
          ),
          new GestureDetector(
            onTap: () {
              _mainKey.currentState.showSnackBar(const SnackBar(
                  content: const Text("button 2 been clicked!")));
            },
            child: buildButtonColumn(Icons.near_me, 'ROUTE'),
          ),
          new GestureDetector(
            onTap: () {
              _mainKey.currentState.showSnackBar(const SnackBar(
                  content: const Text("button 3 been clicked!")));
            },
            child: buildButtonColumn(Icons.share, 'SHARE'),
          )
        ],
      ),
    );
    final textSection = new Padding(
      padding: EdgeInsets.all(32.0),
      child: new Text(
        '''
    Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
    ''',
        softWrap: true,
      ),
    );
    return new Scaffold(
      key: _mainKey,
      body: Column(
        children: <Widget>[
          new Image.asset('images/lake.jpg', width: 600.0, height: 240.0, fit: BoxFit.cover,),
          titleSection,
          buttonSection,
          textSection
        ],
      ),
    );
  }

  Widget buildButtonColumn(IconData icon, String label) {
    Color color = Colors.blue[500];
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          icon,
          color: color,
        ),
        new Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: new Text(
            label,
            style: new TextStyle(
                fontSize: 12.0, fontWeight: FontWeight.w400, color: color),
          ),
        ),
      ],
    );
  }
}
