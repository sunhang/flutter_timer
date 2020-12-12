import 'dart:async';
import 'package:dataclass/dataclass.dart';

enum Command {
  START,
  PAUSE,
  RESUME,
  FINISH,
}

@dataClass
class Result {
  final double second;
  final String status;

  Result(this.second, this.status);
}

@dataClass
class TimeData {
  final StreamController<Result> streamController;
  final double sum;

  TimeData(this.streamController, this.sum);
}

typedef CommandFunc = Function(Command) Function(Command);

CommandFunc _startTimer(final timeData) {
  var sum = timeData.sum;

  // 启动计时
  final timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
    sum += 0.1;
    timeData.streamController.add(Result(sum, '开始了'));
  });

  // 下一个函数
  CommandFunc nextFunc(command) {
    if (command != Command.PAUSE && command != Command.FINISH) {
      return nextFunc;
    }

    final map = {
      Command.PAUSE: () =>
          _handlePause(timer, TimeData(timeData.streamController, sum)),
      Command.FINISH: () => _handleFinish(timer, timeData),
    };
    return map[command].call();
  }

  return nextFunc;
}

CommandFunc _handlePause(final timer, final timeData) {
  timer.cancel();

  // 下一个函数
  CommandFunc nextFunc(command) {
    if (command != Command.RESUME) {
      return nextFunc;
    }
    return _handleResume(timeData);
  }

  return nextFunc;
}

CommandFunc _handleResume(final timeData) {
  final newTimeData = TimeData(timeData.streamController, timeData.sum);
  return _startTimer(newTimeData);
}

CommandFunc _handleFinish(final timer, final timeData) {
  timer.cancel();

  // 下一个函数
  CommandFunc nextFunc(command) {
    if (command != Command.START) {
      return nextFunc;
    }
    final newTimeData = TimeData(timeData.streamController, 0);
    return _startTimer(newTimeData);
  }

  return nextFunc;
}

class TimerController {
  StreamController<Result> _streamController;
  Stream<Result> stream;
  CommandFunc _nextFunc;

  void init() {
    _streamController = StreamController<Result>();
    stream = _streamController.stream;

    final timeData = TimeData(_streamController, 0);

    CommandFunc func(command) {
      if (command != Command.START) {
        return func;
      }
      return _startTimer(timeData);
    }

    _nextFunc = func;
  }

  void dispose() {
    _nextFunc(Command.FINISH);
    _streamController.close();
  }

  void execCommand(Command command) {
    _nextFunc = _nextFunc(command);
  }
}

/*
class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
 */
