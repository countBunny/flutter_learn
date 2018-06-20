import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
      ),
//new MyHomePage(title: 'Flutter Demo Home Page')
      home: new RandomWords(),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) =>
            new MyHomePage(title: 'route destinay a!'),
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _saved = new Set<WordPair>();

  final _menus = <String>[
    'sample view',
    'sample to layout use EdgeInsets.only',
    'sample to use animate',
    'sample to use canvas',
    'sample to custom view',
    'sample to Navigator',
    'sample to share handler obtain intent data!',
    'sample to request http data',
    'sample to visit asset resources',
  ];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
          new IconButton(
              icon: new Icon(Icons.bookmark_border), onPressed: _pushSample)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(itemBuilder: (context, i) {
      if (i.isOdd) return new Divider();
      final index = i ~/ 2; //返回值向下取整的写法
      if (index >= _suggestions.length) {
        //加载更多的实现
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }

  void _pushSample() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      var count = 0;
      final tiles = _menus.map((menu) {
        final index = count++;
        return new ListTile(
          title: new Text(
            menu,
            style: _biggerFont,
          ),
          onTap: () {
            _sampleView(index);
          },
        );
      });
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Test Flutter for Android here!'),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }

  void _sampleView(int index) {
    if (index == 5) {
      getCoodinateInRouteA();
      return;
    }
    print('method didnt reach here!');
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      if (index == 0) {
        return new SampleAppPage();
      } else if (index == 1) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Sample App'),
          ),
          body: new Center(
            child: new MaterialButton(
              onPressed: () {},
              child: new Text('Hello'),
              padding: new EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              color: Colors.cyan,
            ),
          ),
        );
      } else if (index == 2) {
        return new MyFadeTest(
          title: 'Fade Demo',
        );
      } else if (index == 3) {
        return new Signature();
      } else if (index == 4) {
        return customWidget();
      } else if (index == 6) {
        return new SharedIntentPage();
      } else if (index == 7) {
        return new HttpRequestPage();
      } else if (index == 8){
        return new ResourcesVisitPage();
      }else {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Unimplemented page!'),
          ),
          body: new Center(
            child: new Text('sorry, this page havent been implemented'),
          ),
        );
      }
    }));
  }

  Widget customWidget() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Custom Widget'),
      ),
      body: new Center(
        child: new CustomButton('buttonCustomed'),
      ),
    );
  }

  getCoodinateInRouteA() async {
//    Map coordinates = await
    var object = await Navigator.of(context).pushNamed('/a');
    if (object != null) {
      Map coordinates = object;
      print('map is ${coordinates.toString()}');
    }
//    if (coordinates != null) {
//      print('map is ${coordinates.toString()}');
//    }
  }
}

class ResourcesVisitPage extends StatefulWidget {

  ResourcesVisitPage({Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() => new _ResourcesVisitState();
}

class _ResourcesVisitState extends State<ResourcesVisitPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Resources visit demo'),
      ),
      body: new Column(
        children: <Widget>[
          new Image(image: new AssetImage("images/ic_medal.png")),
        ],
      ),
    );
  }
}

class HttpRequestPage extends StatefulWidget {
  HttpRequestPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HttpRequestPageState();
}

class _HttpRequestPageState extends State<HttpRequestPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Http request demo'),
        actions: <Widget>[
          new RaisedButton(
            onPressed: () {
              loadDataInIsolateWay();
            },
            child: new Text('loadData in Isolate way'),
          )
        ],
      ),
      body: getBody(),
    );
  }

  loadData() async {
    String dataUrl = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataUrl);
    setState(() {
      widgets = json.decode(response.body);
    });
  }

  Widget getRow(int i) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Text("Row ${widgets[i]["title"]}"),
    );
  }

  loadDataInIsolateWay() async {
    setState(() {
      widgets.clear();
    });
    ReceivePort receivePort = new ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);
    //acquire isolate's sendPort
    SendPort sendPort = await receivePort.first;
    List msg = await sendReceive(
        sendPort, "https://jsonplaceholder.typicode.com/posts");
    setState(() {
      print("data load Success in Isolate way");
      widgets = msg;
    });
  }

  bool showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    }
    return getListView();
  }

  static dataLoader(SendPort sendPort) async {
    ReceivePort port = new ReceivePort();
    //此函数会即刻执行，阻塞在 await 等待命令输入
    sendPort.send(port.sendPort);
    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];
      String dataURL = data;
      http.Response response = await http.get(dataURL);
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort sendPort, String url) {
    ReceivePort response = new ReceivePort();
    sendPort.send([url, response.sendPort]);
    return response.first;
  }

  getProgressDialog() => new Center(
      child: new CircularProgressIndicator(),
    );

  getListView() => new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        return getRow(index);
      });
}

class SharedIntentPage extends StatefulWidget {
  SharedIntentPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _SharedIntentPageState();
}

class _SharedIntentPageState extends State<SharedIntentPage> {
  static const platform = const MethodChannel('app.channel.shared.data');
  String dataShared = "No data";

  @override
  void initState() {
    super.initState();
    getSharedText();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text(dataShared),
      ),
    );
  }

  getSharedText() async {
    var sharedData = await platform.invokeMethod('getSharedText');
    if (sharedData != null) {
      setState(() {
        dataShared = sharedData;
      });
    }
  }
}

class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      onPressed: () {},
      child: new Text(label),
    );
  }
}

class Signature extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignatureState();
}

class _SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            print("gesture detected!");
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
                referenceBox.globalToLocal(details.globalPosition);
            _points = new List.from(_points)..add(localPosition);
//            painter._points = _points;
          });
        },
        onPanEnd: (DragEndDetails details) => _points.add(null),
        child: new CustomPaint(
          painter: new SignaturePainter(_points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  List<Offset> _points;

  SignaturePainter(this._points);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    print("canvas draw invoked");
    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        canvas.drawLine(_points[i], _points[i + 1], paint);
        print("canvas draw current index is $i");
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) =>
      oldDelegate._points != _points;
}

class MyFadeTest extends StatefulWidget {
  final String title;

  MyFadeTest({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MyFadeTest();
  }
}

class _MyFadeTest extends State<MyFadeTest>
    with TickerProviderStateMixin<MyFadeTest> {
  AnimationController controller;
  CurvedAnimation curve;

  @override
  void initState() {
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new FadeTransition(
          opacity: curve,
          child: new FlutterLogo(
            size: 100.0,
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          controller.forward();
        },
        tooltip: 'Fade',
        child: new Icon(Icons.brush),
      ),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  State<SampleAppPage> createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  String textToShow = 'I Like Flutter';
  bool toggle = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sample Page'),
      ),
      body: new Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }

  void _updateText() {
    setState(() {
      textToShow = 'Flutter is Awesome!';
    });
  }

  _getToggleChild() {
    if (toggle) {
      return new Text(textToShow);
    } else {
      return new MaterialButton(
        onPressed: _updateText,
        child: new Text(textToShow),
        color: Colors.grey,
      );
    }
  }

  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            new RaisedButton(
              onPressed: () {
                Navigator
                    .of(context)
                    .pop({'lat': 43.821757, 'long': -79.226392});
              },
              child: new Text('back with result'),
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
