import 'dart:convert';
import 'dart:io';

import 'package:emergency_call/domain/data/remote/ApiException.dart';
import 'package:http/http.dart';

import '../../../../domain/model/UserPhone.dart';
import '../../../presentation/utility/Strings.dart';
import '../abstraction/UserPhoneRemoteDataSource.dart';

class UserPhoneRemoteDataSourceImpl implements UserPhoneRemoteDataSource {
  // Instance of http client to connect with the server
  Client httpClient = Client();

  @override
  Future saveUserPhone(UserPhone userPhone) async {
    var tokenResponse;
    const endpoint = "/prod/ec_save_phone";

    var uri = Uri.https(Strings.baseApiUrl, endpoint);
    print("UserPhone in remote data source: $uri");

    try {
      final response = await httpClient.post(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-api-key": Strings.apiKey
      },body: jsonEncode(userPhone));

      tokenResponse = _returnResponse(response);
    } on SocketOption {
      throw FetchDataException('No internet connection');
    }

    return tokenResponse;
  }

  // Returns a Json object with the server response if status 200
  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var token = "";
        var responseJson = json.decode(response.body);

        if (responseJson["statusCode"] == 200) {
          var bodyContent = json.decode(responseJson['body']);
          token = bodyContent['token'];
        } else if (responseJson["errorMessage"]?.contains("Task timed out") == true) {
          return null;
        }

        return token;
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
