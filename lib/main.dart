import 'package:flutter/material.dart';
import 'package:timer/TimerController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("跑秒计时器"),
        ),
        body: _MyHomePage(),
      ),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  _MyState createState() {
    return _MyState();
  }
}

class _MyState extends State<_MyHomePage> {
  final _timerController = new TimerController();

  @override
  void initState() {
    super.initState();
    _timerController.init();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<Result>(
          stream: _timerController.stream,
          builder: (context, snapshot) {
            final second = !snapshot.hasData ? 0.0 : snapshot.data.second;
            final status = !snapshot.hasData ? '' : snapshot.data.status;
            return _DisplayWidget(second: second, status: status);
          },
        ),
        _MyTimerOperationWidget(
          callback: (command) {
            _timerController.execCommand(command);
          },
        ),
        SizedBox.fromSize(
          size: Size.fromHeight(150),
        ),
      ],
    );
  }
}

class _DisplayWidget extends StatelessWidget {
  const _DisplayWidget({
    Key key,
    @required this.second,
    @required this.status,
  }) : super(key: key);

  final double second;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${second.toStringAsFixed(1)}秒',
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          ' $status',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}

class _MyTimerOperationWidget extends StatelessWidget {
  final Function(Command) _callback;

  _MyTimerOperationWidget({Function callback}) : _callback = callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RaisedButton(
          child: Text("开始"),
          onPressed: () {
            _callback(Command.START);
          },
        ),
        RaisedButton(
          child: Text("暂停"),
          onPressed: () {
            _callback(Command.PAUSE);
          },
        ),
        RaisedButton(
          child: Text("继续"),
          onPressed: () {
            _callback(Command.RESUME);
          },
        ),
        RaisedButton(
          child: Text("结束"),
          onPressed: () {
            _callback(Command.FINISH);
          },
        ),
      ],
    );
  }
}
