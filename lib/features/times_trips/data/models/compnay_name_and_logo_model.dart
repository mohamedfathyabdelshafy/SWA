class BookingModel {
  final String? departureCompanyName;
  final String? departureCompanyLogo;

  final String? returnCompanyName;
  final String? returnCompanyLogo;

  BookingModel({
    this.departureCompanyName,
    this.departureCompanyLogo,
    this.returnCompanyName,
    this.returnCompanyLogo,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      departureCompanyName: json['departureCompanyName'] ?? '',
      departureCompanyLogo: json['departureCompanyLogo'] ?? '',
      returnCompanyName: json['returnCompanyName'] ?? '',
      returnCompanyLogo: json['returnCompanyLogo'] ?? '',
    );
  }

  BookingModel copyWith({
    String? departureCompanyName,
    String? departureCompanyLogo,
    String? returnCompanyName,
    String? returnCompanyLogo,
  }) {
    return BookingModel(
      departureCompanyName: departureCompanyName ?? this.departureCompanyName,
      departureCompanyLogo: departureCompanyLogo ?? this.departureCompanyLogo,
      returnCompanyName: returnCompanyName ?? this.returnCompanyName,
      returnCompanyLogo: returnCompanyLogo ?? this.returnCompanyLogo,
    );
  }

  @override
  String toString() {
    return '''
BookingModel(
  Departure: {
    companyName: $departureCompanyName,
    companyLogo: $departureCompanyLogo
  },
  Return: {
    companyName: $returnCompanyName,
    companyLogo: $returnCompanyLogo
  }
)''';
  }
}
