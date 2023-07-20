import 'dart:convert';
import 'dart:io';

import 'package:emergency_call/domain/data/remote/ApiException.dart';
import 'package:emergency_call/domain/model/SubscriptionModel.dart';
import 'package:emergency_call/framework/data_source/remote/abstraction/SubscribeRemoteDataSource.dart';
import 'package:emergency_call/framework/presentation/utility/Strings.dart';
import 'package:http/http.dart';

class SubscribeRemoteDataSourceImpl
    implements SubscribeRemoteDataSource {
  // Instance of http client to connect with the server
  Client httpClient = Client();

  @override
  Future subscribeToPremium(
      SubscriptionModel subscriptionPremiumModel) async {
    var responseJson;
    const endpoint = "/prod/ec_subscribe";

    var uri = Uri.https(Strings.baseApiUrl, endpoint);
    print("subscribe to premium end-point: $uri");

    try {
      final response = await httpClient.post(uri,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "x-api-key": Strings.apiKey
          },
          body: jsonEncode(subscriptionPremiumModel));

      responseJson = _returnResponse(response);
    } on SocketOption {
      throw FetchDataException('No internet connection');
    }

    return responseJson['token'];
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
