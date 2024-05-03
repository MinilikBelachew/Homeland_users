import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    try {
      http.Response httpResponse = await http.get(Uri.parse(url));
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body;
        var decodedResponseData = jsonDecode(responseData);
        return decodedResponseData;
      } else {
        return "failed"; // Return a clear indication of failure
      }
    } catch (e) {
      print("Error in getRequest: $e");
      return "failed"; // Return a clear indication of failure
    }
  }
}
