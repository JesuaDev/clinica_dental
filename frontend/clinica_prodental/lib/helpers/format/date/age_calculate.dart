class AgeCalculate {
  static int calculate(dynamic birthday) {
    if (!(birthday != null)) {
      return 0;
    }

    if (birthday is int) {
      return birthday;
    }

    return birthday!.contains('-')
        ? DateTime.now().year - DateTime.parse(birthday!).year
        : int.parse(birthday);
  }
}
