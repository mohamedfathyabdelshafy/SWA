abstract class ApiConsumer {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic body, Map<String, dynamic>? queryParameters});//Map<String, dynamic> instead of dynamic
  Future<dynamic> uploadMultiPart(String path, String imagePath, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});
}