import 'dart:async';
import 'package:rxdart/streams.dart';
import 'model.dart';

typedef CommandFunc = Function(Command) Function(Command);

CommandFunc _createStartFunc(
    final Sink<double> timeSink, final Sink<UI> uiSink) {
  CommandFunc func(command) {
    if (command != Command.START) {
      return func;
    }
    // 启动计时
    var sum = 0.0;
    final timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      sum += 0.1;
      timeSink.add(sum);
    });

    // 下一个函数
    uiSink.add(UI.STARTED);
    return _createStopFunc(timer, timeSink, uiSink);
  }

  return func;
}

CommandFunc _createStopFunc(
    final Timer timer, final Sink<double> timeSink, final Sink<UI> uiSink) {
  // 下一个函数
  CommandFunc func(command) {
    if (command != Command.STOP) {
      return func;
    }

    timer.cancel();
    uiSink.add(UI.STOPED);
    return _createStartFunc(timeSink, uiSink);
  }

  return func;
}

class TimerController {
  CommandFunc _nextFunc;

  StreamController<double> _timeStreamController;
  StreamController<UI> _uiStreamController;
  Stream<UI> uiStream;
  Stream<Event> eventStream;

  void init() {
    _timeStreamController = StreamController<double>();
    _uiStreamController = StreamController<UI>();
    uiStream = _uiStreamController.stream.asBroadcastStream();
    eventStream = CombineLatestStream.combine2(
      _timeStreamController.stream.asBroadcastStream(),
      uiStream,
      (time, ui) => Event(time, ui),
    );

    _nextFunc =
        _createStartFunc(_timeStreamController.sink, _uiStreamController.sink);
  }

  void dispose() {
    _nextFunc(Command.STOP);
    _timeStreamController.close();
    _uiStreamController.close();
  }

  void execCommand(Command command) {
    _nextFunc = _nextFunc(command);
  }
}
