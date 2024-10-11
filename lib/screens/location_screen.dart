import 'dart:convert';
import 'dart:math'; // Import for generating random numbers
import 'package:clima/Services/weather_model.dart';
import 'package:clima/constants/constants.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:clima/Services/location.dart';

class LocationScreen extends StatefulWidget {
  final String cityName;
  const LocationScreen({super.key, required this.cityName});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  var weatherData;

  @override
  void initState() {
    super.initState();
    getLocationAndWeather(); // Call API when screen is initialized
  }

  Future<void> getLocationAndWeather() async {
    try {
      String apiUrl;

      if (widget.cityName.isNotEmpty) {
        apiUrl =
            'https://api.openweathermap.org/data/2.5/weather?q=${widget.cityName}&appid=ccfd7857478befdb04e8b6bb0e33d2d5';
      } else {
        Position position = await locationServices().determinePosition();
        double latitude = position.latitude;
        double longitude = position.longitude;
        apiUrl =
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=ccfd7857478befdb04e8b6bb0e33d2d5';
      }

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = jsonDecode(response.body);
        });
      } else {
        print('Error: ${response.statusCode}');
        // Fetch random data if there is an error
        fetchRandomWeatherData();
      }
    } catch (e) {
      print('Error: $e');
      // Fetch random data in case of exception
      fetchRandomWeatherData();
    }
  }

  void fetchRandomWeatherData() {
    // Generate random weather data
    Random random = Random();
    int randomCondition = random.nextInt(800) +
        200; // Simulate weather condition IDs (200 to 999)
    double randomTemp = random.nextDouble() *
        40; // Random temperature between 0 and 40 degrees Celsius
    String randomCity = "Random City";

    // Update the state with random data
    setState(() {
      weatherData = {
        'weather': [
          {'id': randomCondition}
        ],
        'main': {'temp': randomTemp + 273.15}, // Convert to Kelvin
        'name': randomCity,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    double tempInCelsius =
        weatherData == null ? 0 : weatherData['main']['temp'] - 273.15;
    int condition = weatherData == null ? 0 : weatherData['weather'][0]['id'];
    String getWeatherIcon =
        weatherModel.getWeatherIcon(condition); // Get weather icon
    String getMessage =
        weatherModel.getMessage(tempInCelsius.toInt()); // Get message
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/location_background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(1), BlendMode.dstATop),
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: weatherData == null
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationScreen(
                                              cityName: '',
                                            )));
                              },
                              child: Icon(
                                Icons.near_me,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CityScreen()));
                              },
                              child: Icon(
                                Icons.location_city,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${tempInCelsius.toInt()}°C ', // Temperature text
                                    style:
                                        kTempTextStyle, // Style for temperature
                                  ),
                                  TextSpan(
                                    text: getWeatherIcon, // Weather icon text
                                    style: kTempTextStyle.copyWith(
                                        color: Colors
                                            .blue), // Separate color for icon
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "${getMessage} in ${weatherData['name']}!",
                              style: kMessageTextStyle,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
