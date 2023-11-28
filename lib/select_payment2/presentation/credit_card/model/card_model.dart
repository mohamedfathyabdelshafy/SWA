class CardModel {
  String? cardName;
  String? month;
  String? cardNumber;

  CardModel(
  {
    required this.month,
    required this.cardName,
    required this.cardNumber
});

  factory  CardModel.fromJsom(dynamic json){
    return CardModel(
      cardName: json['cardName']??"",
        month :json['month']??"",
    cardNumber:json['cardNumber']??""
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'cardName':cardName,
      'month':month,
      'cardNumber':cardNumber,
    };
  }
}