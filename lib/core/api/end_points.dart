class EndPoints {
  static const String baseUrl = 'http://api.swabus.com/api/';
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
  static const String personalEdit = '${baseUrl}Customer/EditCustomer';
  static const String chargecard = '${baseUrl}Fawry/CardPayment';
  static const String aboutUs = '${baseUrl}Settings/AboutUs';

}
