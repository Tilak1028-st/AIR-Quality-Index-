import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restapi/screens/cityscreen.dart';
import 'package:restapi/screens/constant.dart';
import 'package:restapi/screens/weather.dart';


class Locationt{

  late double latitude;
  late double longitude;


  Future<void> getCurrentAQI() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch(e){
      print(e);
    }
  }
}

class AqiScreen extends StatefulWidget {
  AqiScreen({this.locationWeather});

  final locationWeather;

  @override
  _AqiScreenState createState() => _AqiScreenState();
}

class _AqiScreenState extends State<AqiScreen> {

  AqiModel weather = AqiModel();

  late int temperature;
  late String city;
  late String weatherMessage;
  late double co;
  late String c_code;
  late double pm25;
  late double pm10;
  late double so2;
  late double no2;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic aqiData) {
    setState(() {
      if (aqiData == null) {
        temperature = 0;
        weatherMessage = 'Unable to get AQI data';
        city = '';
        return;
      }

      int aqi = aqiData['data'][0]['aqi'];
      temperature = aqi.toInt();
      city = aqiData['city_name'];
      co = aqiData['data'][0]['co'].roundToDouble();
      pm25= aqiData['data'][0]['pm25'].roundToDouble();
      pm10= aqiData['data'][0]['pm10'].roundToDouble();
      so2= aqiData['data'][0]['so2'].roundToDouble();
      no2= aqiData['data'][0]['no2'].roundToDouble();
      c_code = aqiData['country_code'];
      weatherMessage = weather.getMessage(temperature);
    });
  }

  String _getBackGround(int aqi) {
    if (aqi > 0 && aqi <= 50) {
      return "images/green.jpg";
    } else if (aqi > 50 && aqi <= 100) {
      return "images/yellow.png";
    } else if (aqi > 100 && aqi <= 150) {
      return "images/background.png";
    } else if (aqi > 150) {
      return "images/red.jpg";
    }
    else
      return "images/red.jpg";
  }

  String _getIcon(int aqi) {
    if (aqi > 0 && aqi <= 50) {
      return "images/breath.png";
    } else if (aqi > 50 && aqi <= 100) {
      return "images/breath.png";
    } else if (aqi > 100 && aqi <= 150) {
      return "images/face-mask.png";
    } else if (aqi > 150) {
      return "images/air-pollution (1).png";
    }
    else
      return "images/air-pollution.png";
  }

  Container MyCard(String a){
    return Container(
      width: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
          )
        ),
        color: Colors.white70,
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children : <Widget>[
           Icon(Icons.cloud,
             color: Colors.deepOrange,
           ),
         SizedBox(height: 5,),
         Text(a,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        ]
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage(_getBackGround(temperature)),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  Row(
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () async {
                          var weatherData = await weather.getAQI();
                          updateUI(weatherData);
                        },
                        child: Icon(
                          Icons.near_me,
                          size: 50.0,
                        ),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () async {
                          var typedName = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                            return CityScreen();
                          },
                          ),
                          );
                          if (typedName != null) {
                            var weatherData = await weather.getCityAQI(
                                typedName);
                            updateUI(weatherData);
                          }
                        },
                        child: Icon(
                          Icons.location_city,
                          size: 50.0,
                        ),
                      ),
                    ],
                  ),
                     Container(
                     child: Column(
                        children: <Widget>[
                          Image(image: AssetImage(_getIcon(temperature)),
                            width: 300,
                          ),
                          Text(
                            ' AQI Level is $weatherMessage in  $city',
                            textAlign: TextAlign.center,
                            style: kMessageTextStyle,
                          ),
                          Text(
                            '$temperature',
                            style: kTempTextStyle,
                          ),
                          SizedBox(width: 10,),
                          Text("Pollutant Levels",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[

                                SizedBox(width: 10,),
                                MyCard('$pm10  \n  PM10'),
                                SizedBox(width: 10,),
                                MyCard('$pm25 \n PM25'),
                                SizedBox(width: 10,),
                                MyCard('$co \n  CO'),
                                SizedBox(width: 10,),
                                MyCard('$so2 \n So2'),
                                SizedBox(width: 10,),
                                MyCard('$no2 \n No2'),
                              ],
                            ),
                          ),
                        ],
                      ),
                     ),
                  SizedBox(height: 22),
                  Image(image: AssetImage('images/aqi.jpg')),
                ]
            ),
          ),
        ),
        ),
    );
  }
}