import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

class WebSocketPage extends StatefulWidget {
  WebSocketPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _WebSocketState();
}

class _WebSocketState extends State<WebSocketPage> {
  TextEditingController _controller;
  final _words = <String>[];
  WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _controller.addListener(() {
      print(_controller.value);
    });
    while (null == _channel) {
      try {
        final uri = Uri.base.resolve("ws://121.40.165.18:8800");
        print('resolved uri is $uri port is ${uri.port}');
        _channel = new IOWebSocketChannel.connect(
            uri); //ws://echo.websocket.org
        _channel.stream.listen((data) {
          print('server reply:$data');
          setState(() {
            _words.add('server reply: $data');
          });
        });
        throw new WebSocketChannelException("auto throw if can be caught");
      } on WebSocketChannelException catch (ex) {
        print("webSocketChannel bad $ex");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputWidget = new Container(
      height: 40.0,
      padding: EdgeInsets.all(5.0),
      alignment: Alignment.bottomCenter,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: Colors.grey[200]))),
      child: new Row(
        children: <Widget>[
          new Flexible(
              child: new TextField(
            decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(5.0),
                hintText: 'text to send out input here',
                border: OutlineInputBorder(
                    borderSide: new BorderSide(
                  color: Colors.grey[200],
                ))),
            controller: _controller,
          )),
          new Container(
            margin: EdgeInsets.only(left: 10.0),
            child: new RaisedButton(
              onPressed: _send,
              child: new Text('Send'),
            ),
          )
        ],
      ),
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Socket Communication'),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  reverse: true,
                  itemCount: _words.length,
                  itemBuilder: (context, index) {
                    return new Align(
                      alignment: Alignment.centerLeft,
                      child: new Container(
                        margin: EdgeInsets.all(10.0),
                        child: new Text(_words[index]),
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(5.0),
                            color: Colors.blue[100]),
                        padding: EdgeInsets.all(4.0),
                      ),
                    );
                  })),
          inputWidget
        ],
      ),
    );
  }

  void _send() {
    final text = _controller.value.text;
    if (null == text || text.isEmpty) {
      return;
    }
    _controller.clear();
    if (_channel != null && _channel.sink != null) {
      print('send through socket');
      _channel.sink.add(text);
    }
    setState(() {
      _words.add('client said: $text');
    });
  }
}
