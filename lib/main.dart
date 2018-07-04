import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_try/anim_demo/list_anim_demo.dart';
import 'package:flutter_try/anim_demo/scale_anim_demo.dart';
import 'package:flutter_try/card_demo1.dart';
import 'package:flutter_try/card_demo2.dart';
import 'package:flutter_try/chart_demo/chart_page.dart';
import 'package:flutter_try/chat_demo/chat_offline.dart';
import 'package:flutter_try/color_demo.dart';
import 'package:flutter_try/contract_demo.dart';
import 'package:flutter_try/image_picker_demo.dart';
import 'package:flutter_try/input_demo.dart';
import 'package:flutter_try/layout_demo1.dart';
import 'package:flutter_try/listview_demo.dart';
import 'package:flutter_try/location_demo.dart';
import 'package:flutter_try/official/layout_official_demo.dart';
import 'package:flutter_try/official/state_control_demo.dart';
import 'package:flutter_try/shared_preferences_demo.dart';
import 'package:flutter_try/sqflite_demo.dart';
import 'package:flutter_try/text_demo.dart';
import 'package:flutter_try/utils.dart';
import 'package:flutter_try/video_player_demo.dart';
import 'package:flutter_try/websocket/web_socket_demo.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    debugPaintSizeEnabled = true;
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
      return new DemoListPage();
    }));
  }
}

class DemoListPage extends StatefulWidget {
  final _menus = <Map<int, String>>[
    {0: 'sample view'},
    {1: 'sample to layout use EdgeInsets.only'},
    {2: 'sample to use animate'},
    {3: 'sample to use canvas'},
    {4: 'sample to custom view'},
    {5: 'sample to Navigator'},
    {6: 'sample to share handler obtain intent data!'},
    {7: 'sample to request http data'},
    {8: 'sample to visit asset resources'},
    {9: 'sample to supervisor lifecycle event'},
    {10: 'sample to layouts'},
    {11: 'layouts demo1 from stackOverflow'},
    {12: 'sample to gestureDetector'},
    {13: 'sample to use listView'},
    {14: 'sample to use Text in custom way'},
    {15: 'sample to table input'},
    {16: 'sample to use ImagePicker'},
    {17: 'sample to use VideoPlayer'},
    {18: 'sample to use sharedPreferences'},
    {19: 'sample to use sqflite'},
    {20: 'sample to color demo'},
    {21: 'sample to contacts demo'},
    {22: 'sample to card demo1'},
    {23: 'sample to card demo2'},
    {24: 'sample to chart demo with CustomPainter'},
    {25: 'official demo to learn how to layout'},
    {26: 'official demo to learn how to interact'},
    {27: 'sample to anim list'},
    {28: 'sample to chat anim demo'},
    {29: 'sample to scale anim demo'},
    {30: 'sample to connect websocket'},
  ];

  DemoListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DemoListState();
}

class _DemoListState extends State<DemoListPage> {
  static GlobalKey<ScaffoldState> _globelScaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Decoration decoration = new BoxDecoration(
      border: new Border(
        bottom: Divider.createBorderSide(context),
      ),
    );
    return new Scaffold(
      key: _globelScaffoldState,
      appBar: new AppBar(
        title: new Text('Test Flutter for Android here!'),
      ),
      body: new ListView.builder(
        itemBuilder: (context, index) {
          return new DecoratedBox(
            decoration: decoration,
            position: DecorationPosition.foreground,
            child: new Dismissible(
                key: new Key(index.toString()),
                onDismissed: (direction) {
                  widget._menus.removeAt(index);
                  _globelScaffoldState.currentState.showSnackBar(
                      new SnackBar(content: new Text('$index been deleted')));
                },
                background: new Container(
                  color: Colors.red[300],
                  child: new Center(
                    child: new Text(
                      'you are removing this item!',
                      style: new TextStyle(color: Colors.yellow[200]),
                    ),
                  ),
                ),
                child: new ListTile(
                  title: new Text(
                    widget._menus[index].entries.first.value,
                  ),
                  onTap: () {
                    _sampleView(widget._menus[index].entries.first.key);
                  },
                )),
          );
        },
        itemCount: widget._menus.length,
      ),
    );
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
      } else if (index == 8) {
        return new ResourcesVisitPage();
      } else if (index == 9) {
        return new LifecycleWatcher();
      } else if (index == 10) {
        return new LayoutsPage();
      } else if (index == 11) {
        return new LayoutDemoApp();
      } else if (index == 12) {
        return new GestureDetectorPage();
      } else if (index == 13) {
        return new ListViewPage();
      } else if (index == 14) {
        return new TextPage();
      } else if (index == 15) {
        return new InputPage();
      } else if (index == 16) {
        return new ImagePickerPage('ImagePicker demo');
      } else if (index == 17) {
        return new VideoPlayerPage();
      } else if (index == 18) {
        return new SharedPreferencesPage();
      } else if (index == 19) {
        return new SqflitePage();
      } else if (index == 20) {
        return new ColorsDemo();
      } else if (index == 21) {
        return new ContactsDemo();
      } else if (index == 22) {
        return new CardDemo1(
          title: 'card demo1',
        );
      } else if (index == 23) {
        return new CardsDemo();
      } else if (index == 24) {
        return new ChartPage();
      } else if (index == 25) {
        return new LayoutDemoPage();
      } else if (index == 26) {
        return new ParentWidget();
      } else if (index == 27) {
        return new AnimatedListSample();
      } else if (index == 28) {
        return new FriendlychatApp();
      } else if (index == 29) {
        return new ScaleAnimationPage();
      } else if (index == 30) {
        return new WebSocketPage();
      } else {
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
}

class GestureDetectorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _GestureDetectorState();
}

class _GestureDetectorState extends State<GestureDetectorPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    curve = new CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new GestureDetector(
          child: new RotationTransition(
            turns: curve,
            child: new FlutterLogo(
              size: 200.0,
            ),
          ),
          onDoubleTap: () {
            if (_controller.isCompleted) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          },
        ),
      ),
    );
  }
}

class LayoutsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Layouts sample'),
      ),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text('Row One'),
                new Text('Row Two'),
                new Text('Row Three'),
                new Text('Row Four'),
              ],
            ),
            new Text('Column Two'),
            new Text('Column Three'),
            new Text('Column Four'),
          ],
        ),
      ),
    );
  }
}

class LifecycleWatcher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("lifecycle changed to $state");
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == null) {
      return new Center(
        child: new Text(
          'This widget has not observed any lifecycle changes.',
          textDirection: TextDirection.ltr,
        ),
      );
    }
    return new Center(
      child: new Text(
        'The most recent lifecycle state this widget observed was：$_lastLifecycleState.',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

class ResourcesVisitPage extends StatefulWidget {
  ResourcesVisitPage({Key key}) : super(key: key);

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
          new Text(Strings.welcomeMessage)
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
