import 'dart:async';
import 'dart:core';
import 'package:restapi/screens/location.dart';
import 'package:restapi/screens/networking.dart';

const apiKey = '45ac1cb16210447387f43f0872eabf79';
const openWeatherMapURL = 'https://api.weatherbit.io/v2.0/current/airquality';


class AqiModel {

  Future<dynamic> getCityAQI(String city) async {
    NetworkHelper networkHelper = NetworkHelper
      ('$openWeatherMapURL?city=$city&key=$apiKey');
    var aqiData = await networkHelper.getData();
    return aqiData;
  }

  Future<dynamic> getAQI() async {
    Locationt location = Locationt();
    await location.getCurrentAQI();


    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location
            .longitude}&key=$apiKey');

    var aqiData = await networkHelper.getData();

    return aqiData;
  }
  String getMessage(int aqi) {
    if (aqi > 0 && aqi <=  50) {
      return 'Good';
    } else if (aqi > 50 && aqi <= 100) {
      return 'Moderate';
    } else if ( aqi > 100 && aqi <= 150) {
      return 'Unhealty for Sensitive Groups';
    } else if (aqi > 150) {
      return 'Very Unhealty';
    }
    else
      return 'Hazardous';
  }
}