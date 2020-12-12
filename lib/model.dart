import 'package:dataclass/dataclass.dart';

enum Command {
  START,
  STOP,
}

enum UI {
  STARTED,
  STOPED,
}

@dataClass
class Event {
  final double time;
  final UI ui;

  Event(this.time, this.ui);
}