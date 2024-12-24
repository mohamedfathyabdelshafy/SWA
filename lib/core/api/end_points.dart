class EndPoints {
  static const String baseUrl = 'https://api.swabus.com/api/';
  // static const String baseUrl = 'http://testapi.swabus.com/api/';
  static const String register = '${baseUrl}Customer/AddCustomer';
  static const String login = '${baseUrl}Accounts/Login';
  static const String resetPassword = '${baseUrl}Accounts/ResetPassword';
  static const String changePassword = '${baseUrl}Accounts/ChangePassword';
  static const String getFromStationsList =
      '${baseUrl}/Stations/GetSationListFrom';
  static const String getToStationsList = '${baseUrl}/Stations/GetSationListTo';
  static const String fawryPaymentMethod = '${baseUrl}Fawry/RefNumPayment';
  static const String eWalletPaymentMethod = '${baseUrl}Fawry/EwalletPayment';
  static const String timesTrips = '${baseUrl}Trip/GetTrips';
  static const String busLayout = '${baseUrl}Trip/GetSingleTripDetails';
  static const String reservation = '${baseUrl}Reservation/AddReservation';

  static const String reservationUmra = '${baseUrl}TripUmra/AddReservation';

  static const String paypackage = '${baseUrl}Package/SubscribePackage';
  static const String checkpromocode = '${baseUrl}Reservation/CheckPromoCode';

  static const String personalEdit = '${baseUrl}Customer/EditCustomer';
  static const String chargecard = '${baseUrl}Fawry/CardPayment';
  static const String aboutUs = '${baseUrl}Settings/AboutUs';
  static const String stations =
      '${baseUrl}Stations/SationListFromCityRepeated';
  static const String busClass = '${baseUrl}Bus/BusServiceClasses';
  static const String lines = '${baseUrl}Lines/Lines';
  static const String termsAndCondition =
      '${baseUrl}Settings/TermsAndConditionsList';
  static const String FAQ = '${baseUrl}Settings/FAQ';
  static const String privacy = '${baseUrl}Settings/PrivacyPolicyList';
  static const String sendEmail = '${baseUrl}Settings/SubmitContactUsMessage';

  static const String huaweiVersion = "1.0.9";
  static const String playStoreVersion = "1.0.9";
  static const String iosVersion = "2.0.8";
}
