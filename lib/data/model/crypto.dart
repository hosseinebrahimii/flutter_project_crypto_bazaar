class Crypto {
  String id;
  String name;
  String symbol;
  double changePercent24Hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  Crypto(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24Hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  factory Crypto.getFromJsonMap(Map<String, dynamic> jsonMap) {
    return Crypto(
      jsonMap['id'],
      jsonMap['name'],
      jsonMap['symbol'],
      double.parse(jsonMap['changePercent24Hr']),
      double.parse(jsonMap['priceUsd']),
      double.parse(jsonMap['marketCapUsd']),
      int.parse(jsonMap['rank']),
    );
  }
}
