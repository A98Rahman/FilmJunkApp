import 'package:http/http.dart';

class NetworkCalls {
  Future<String> getData(String url) async {
    var headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.76 Safari/537.36'};
    var response = await get(url,headers: headers);
    checkAndThrowError(response);
    return response.body;
  }

  static void checkAndThrowError(Response response) {
    if (response.statusCode != 200) throw Exception(response.body);
  }
}
