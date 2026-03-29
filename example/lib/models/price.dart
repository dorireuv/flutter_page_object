class Price {
  final int totalCents;

  const Price(this.totalCents);

  factory Price.fromNum(num n) => Price((n * 100).toInt());

  static Price? fromDisplayString(String? str) {
    if (str == null || str.isEmpty) {
      return null;
    }
    return Price.fromNum((double.parse(str.substring(1))));
  }

  String toDisplayString() => '\$${(totalCents / 100).toStringAsFixed(2)}';

  @override
  String toString() => 'Price(totalCents: $totalCents)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Price && other.totalCents == totalCents;
  }

  @override
  int get hashCode => totalCents.hashCode;
}
