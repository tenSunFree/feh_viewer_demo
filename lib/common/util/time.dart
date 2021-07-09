final Time time = Time();

class Time {
  int? lastTime;

  void showTime(String tag) {
    final int nowTime = DateTime.now().millisecondsSinceEpoch;
    lastTime = nowTime;
  }
}
