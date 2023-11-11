class EndPoints {
  // static const String baseUrl = 'http://api.swabus.com/api/';
  static const String baseUrl = 'http://testapi.swabus.com/api/';
  static const String register = '${baseUrl}Customer/AddCustomer';
  static const String login = '${baseUrl}Accounts/Login';
  static const String resetPassword = '${baseUrl}Accounts/ResetPassword';
  static const String changePassword = '${baseUrl}Accounts/ChangePassword';
  static const String getFromStationsList = '${baseUrl}/Stations/GetSationListFrom';
  static const String getToStationsList = '${baseUrl}/Stations/GetSationListTo';
}