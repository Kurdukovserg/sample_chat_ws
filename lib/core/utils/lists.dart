extension ExtendedList<T> on List<T> {
  List<T> separated(T separator) {
    if (isEmpty) {
      return this;
    }
    return [
      ...take(length - 1).expand((element) => [element, separator]),
      last,
    ];
  }
}
