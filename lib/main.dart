import 'package:flutter/material.dart';
import 'package:timer/controller.dart';

import 'model.dart';

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
        StreamBuilder<Event>(
          stream: _timerController.eventStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _DisplayWidget(seconds: 0, status: '');
            }
            final time = snapshot.data.time;
            final status = snapshot.data.ui == UI.STARTED ? '已开始' : '已结束';
            return _DisplayWidget(seconds: time, status: status);
          },
        ),
        _MyTimerOperationWidget(
          timerController: _timerController,
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

class _MyTimerOperationWidget extends StatelessWidget {
  final Function(Command) _callback;
  final TimerController _timerController;

  _MyTimerOperationWidget({
    TimerController timerController,
    Function callback,
  })  : _timerController = timerController,
        _callback = callback;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _timerController.uiStream,
        builder: (context, snapshot) {
          final uiState = snapshot.hasData ? snapshot.data : UI.STOPED;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RaisedButtonWidget(
                title: '开始',
                enabled: uiState == UI.STOPED,
                onPressed: () {
                  _callback(Command.START);
                },
              ),
              _RaisedButtonWidget(
                title: '结束',
                enabled: uiState == UI.STARTED,
                onPressed: () {
                  _callback(Command.STOP);
                },
              ),
            ],
          );
        });
  }
}

class _DisplayWidget extends StatelessWidget {
  const _DisplayWidget({
    Key key,
    @required this.seconds,
    @required this.status,
  }) : super(key: key);

  final double seconds;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${seconds.toStringAsFixed(1)}秒',
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

class _RaisedButtonWidget extends StatelessWidget {
  final String title;
  final Function _onPressed;
  final bool enabled;

  _RaisedButtonWidget({this.title, this.enabled, Function onPressed})
      : _onPressed = (enabled ? onPressed : null);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(title),
      onPressed: _onPressed,
    );
  }
}
