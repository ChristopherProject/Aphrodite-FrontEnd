import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class Requests {
  static late String authToken;
  static late String username;
  static late String password;

  static Future<void> saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  static Future<void> saveCredentials(String username, String passwrod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', passwrod);
  }

  static Future<void> loadSavedJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken') ?? '';
  }

  static Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
    password = prefs.getString('password') ?? '';
  }

  static Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('authToken');
  }

  static Future<void> refreshAuthToken(String username, String password) async {
    final Map<String, String> data = {
      'username': username,
      'password': password,
    };

    final Uri url = Uri.parse('http://194.36.26.23:419/api/login');

    try {
      final http.Response response = await http.post(
        url,
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('authToken')) {
        authToken = responseData['authToken'];
        await saveAuthToken(authToken);
        await saveCredentials(username, password);
      }
      // ignore: empty_catches
    } catch (error) {}
  }

  static Future<Map<String, dynamic>> getCurrentAccountData() async {
    await loadCredentials();
    await refreshAuthToken(username, password);
    await loadSavedJWT();
    final Uri data = Uri.parse('http://194.36.26.23:419/api/getMe');
    try {
      final http.Response userDataResponse = await http.get(
        data,
        headers: {'Authorization': 'Bearer $authToken'},
      );

      final Map<String, dynamic> responseData =
          json.decode(userDataResponse.body);

      if (responseData.containsKey('user_id')) {
        return responseData;
      }
    } catch (error) {
      return {};
    }
    return {};
  }

  static Future<Map<String, dynamic>> fetchUserInformation(String userId) async {
    await loadCredentials();
    await refreshAuthToken(username, password);
    await loadSavedJWT();
    final Uri userData =
        Uri.parse('http://194.36.26.23:419/api/getUserById?user_id=$userId');
    try {
      final http.Response userInformationResponse = await http.get(
        userData,
        headers: {'Authorization': 'Bearer $authToken'},
      );

      final Map<String, dynamic> userInfoData =
          json.decode(userInformationResponse.body);

      if (userInfoData.containsKey('username')) {
        return userInfoData;
      }
    } catch (error) {
      return {};
    }
    return {};
  }

    static Future<Map<String, dynamic>> findUserInformationsByName(String username) async {
    await loadCredentials();
    await refreshAuthToken(username, password);
    await loadSavedJWT();
    final Uri userData = Uri.parse('http://194.36.26.23:419/api/getUserByName?username=$username');
    try {
      final http.Response userInformationResponse = await http.get(
        userData,
        headers: {'Authorization': 'Bearer $authToken'},
      );

      final Map<String, dynamic> userInfoData =  json.decode(userInformationResponse.body);


        return userInfoData;
      
    } catch (error) {
      return {};
    }
  }
}
