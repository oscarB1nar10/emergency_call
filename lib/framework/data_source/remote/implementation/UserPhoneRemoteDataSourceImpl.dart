import 'dart:convert';
import 'dart:io';

import 'package:emergency_call/domain/data/remote/ApiException.dart';
import 'package:http/http.dart';

import '../../../../domain/model/UserPhone.dart';
import '../abstraction/UserPhoneRemoteDataSource.dart';

class UserPhoneRemoteDataSourceImpl implements UserPhoneRemoteDataSource {
  final String baseUrl = "192.168.20.21";

  // Instance of http client to connection with the server
  Client httpClient = Client();

  @override
  Future saveUserPhone(UserPhone userPhone) async {
    var responseJson;
    const endpoint = "/api/userPhone";
    var queryParameters = {'id': userPhone.id, 'name': userPhone.name};

    var uri = Uri.https(baseUrl, endpoint, queryParameters);
    print("UserPhone in remote data source: $uri");

    try {
      final response = await httpClient.post(uri,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      responseJson = _returnResponse(response);
    } on SocketOption {
      throw FetchDataException('No internet connection');
    }

    return responseJson;
  }

  // Returns a Json object with the server response if status 200
  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        print(responseJson);
        return responseJson;

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
