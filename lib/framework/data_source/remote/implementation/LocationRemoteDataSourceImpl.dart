import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emergency_call/domain/data/remote/ApiException.dart';
import 'package:emergency_call/domain/model/Location.dart';
import 'package:emergency_call/domain/model/SaveLocationResponse.dart';
import 'package:emergency_call/framework/data_source/remote/abstraction/LocationRemoteDataSource.dart';
import 'package:http/http.dart';

import '../../../../domain/model/ErrorType.dart';
import '../../../presentation/utility/Strings.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  // Instance of http client to connection with the server
  Client httpClient = Client();

  @override
  Future saveLocation(UserLocation location) async {
    var saveLocationResponse = SaveLocationResponse();
    const endpoint = "/prod/ec_save_location";

    var uri = Uri.https(Strings.baseApiUrl, endpoint);
    print("Location in remote data source: $uri");

    try {
      final response = await httpClient.post(uri,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "x-api-key": Strings.apiKey
          },
          body: jsonEncode(location));

      saveLocationResponse = _returnResponse(response);
    } on SocketOption {
      throw FetchDataException('No internet connection');
    } on TimeoutException {
      // Time out is considered as a valid attempt to save, just keep trying
      saveLocationResponse.wasLocationSaved = true;
      saveLocationResponse.errorType = TimeOutError("Task timed out");
    }

    return saveLocationResponse;
  }

  // Returns a Json object with the server response if status 200
  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var saveLocationResponse = SaveLocationResponse();
        var responseJson = json.decode(response.body);
        print(responseJson);

        if (responseJson["statusCode"] == 200) {
          saveLocationResponse.wasLocationSaved = true;
        } else if (responseJson["statusCode"] == 401) {
          saveLocationResponse.errorType =
              UnauthorizedError("The token is expired");
        } else if (responseJson["errorMessage"]?.contains("Task timed out") ==
            true) {
          saveLocationResponse.errorType = TimeOutError("Task timed out");
        }

        return saveLocationResponse;

      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
