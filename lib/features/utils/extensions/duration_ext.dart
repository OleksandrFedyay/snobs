extension DurationExt on Duration {
  String getString() {
    final int seconds = inSeconds.remainder(60);
    return '$inMinutes:${seconds < 10 ? '0$seconds' : seconds}';
  }
}
