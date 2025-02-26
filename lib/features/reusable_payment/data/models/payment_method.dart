class PaymentMethod {
  final int id;
  final String name;
  final String image;
  final String description;
  final PaymentMethodType type;
  final bool isComingSoon;
  final bool hasWalletBalance;

  PaymentMethod(
      {required this.id,
      required this.name,
      required this.image,
      required this.description,
      required this.type,
      required this.isComingSoon,
      required this.hasWalletBalance});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['PageID'],
      name: json['PageName'],
      image: (json['Image'] as String?)?.isNotEmpty == true
          ? json['Image']
          : 'https://cdn0.iconfinder.com/data/icons/shift-free/32/Error-512.png',
      description: json['Description'],
      isComingSoon: json['IsComingSoon'],
      hasWalletBalance: json['HasWalletBalance'],
      type: _parsePaymentMethodType(json['PageID']),
    );
  }

  static PaymentMethodType _parsePaymentMethodType(int pageID) {
    switch (pageID) {
      case 1:
        return PaymentMethodType.wallet;
      case 2:
        return PaymentMethodType.creditCard;
      case 3:
        return PaymentMethodType.fawry;
      case 4:
        return PaymentMethodType.electronicWallet;
      default:
        throw ArgumentError('Invalid PaymentMethodType: $pageID');
    }
  }
}

enum PaymentMethodType { creditCard, fawry, wallet, electronicWallet }
