import 'dart:async';

class TimerPresenter {
  Timer _timer;
  StreamController<double> _streamController = StreamController<double>();

  Stream<double> get stream => _streamController.stream;
  double _sum = 0;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _sum += 0.1;
      _streamController.add(_sum);
    });
  }

  void resume() => start();

  void pause() {
    _timer?.cancel();
  }

  void stop() => pause();
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
