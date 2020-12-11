import 'package:flutter/material.dart';
import 'package:timer/TimerPresenter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatelessWidget {
  final _timerPresenter = new TimerPresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("跑秒计时器"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<double>(
            stream: _timerPresenter.stream,
            builder: (context, snapshot) {
              final second = !snapshot.hasData ? 0.0 : snapshot.data;
              return Text(
                '${second.toStringAsFixed(1)}秒',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          _MyTimerOperationWidget(
            onStart: () {
              _timerPresenter.start();
            },
            onPause: () {
              _timerPresenter.pause();
            },
            onResume: () {
              _timerPresenter.resume();
            },
            onStop: () {
              _timerPresenter.stop();
            },
          ),
          SizedBox.fromSize(
            size: Size.fromHeight(150),
          ),
        ],
      ),
    );
  }
}

class _MyTimerOperationWidget extends StatelessWidget {
  final Function _onStart;
  final Function _onPause;
  final Function _onResume;
  final Function _onStop;

  _MyTimerOperationWidget(
      {Function onStart, Function onPause, Function onResume, Function onStop})
      : _onStart = onStart,
        _onPause = onPause,
        _onResume = onResume,
        _onStop = onStop;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RaisedButton(
          child: Text("开始"),
          onPressed: () {
            _onStart();
          },
        ),
        RaisedButton(
          child: Text("暂停"),
          onPressed: () {
            _onPause();
          },
        ),
        RaisedButton(
          child: Text("继续"),
          onPressed: () {
            _onResume();
          },
        ),
        RaisedButton(
          child: Text("结束"),
          onPressed: () {
            _onStop();
          },
        ),
      ],
    );
  }
}
