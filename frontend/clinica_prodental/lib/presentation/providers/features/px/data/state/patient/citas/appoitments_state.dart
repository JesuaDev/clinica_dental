class AppoitmentsState {
  final int? scheduled;

  final int? complete;
  final int? wait;
  final int? cancel;
  final int? postponed;

  AppoitmentsState({
    this.scheduled,
    this.complete,
    this.wait,
    this.cancel,
    this.postponed,
  });
}
