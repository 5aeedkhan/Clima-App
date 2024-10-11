import 'package:clima/constants/constants.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final TextEditingController _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/city_background.jpg',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(1), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _cityController,
                style: kFieldTextStyle,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.location_city,
                      size: 50,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    fillColor: Colors.white,
                    label: Text(
                      'City',
                      style: kFieldTextStyle,
                    ),
                    hintText: 'City Name',
                    hoverColor: Colors.white,
                    hintStyle: kFieldTextStyle),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    String cityName = _cityController.text;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LocationScreen(cityName: cityName)));
                  },
                  child: Text('Get Weather'))
            ],
          ),
        ),
      ),
    );
  }
}
