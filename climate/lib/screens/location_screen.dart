import 'package:climate/screens/weather_forecast_screen.dart';
import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'package:climate/services/weather.dart';
import 'city_screen.dart';
import 'map_screen.dart';
import 'package:climate/main.dart';
import 'favorite_city_screen.dart';
import 'package:provider/provider.dart';
import 'package:climate/services/feedback.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  List<String> cities = [];
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  String weatherImage;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        weatherImage = '';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      weatherImage = weather.getWeatherImage(condition);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    DarkMode _mode = Provider.of<DarkMode>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(weatherImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      SoundService.instance.playTapDownSound();
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ), TextButton(
                    onPressed: () async {
                      var weatherData = await WeatherModel().getFiveDayWeatherForecast(cityName);
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WeatherForecastScreen(weatherData, cityName);
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData = await weather.getLocationWeather();
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.satellite_alt,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      SoundService.instance.playTapDownSound();
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MapScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.map,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      SoundService.instance.playTapDownSound();
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      SoundService.instance.playTapDownSound();
                      List<String> cities = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return favorite_city_screen(widget.cities);
                          },
                        ),
                      );

                      if (cities != null) {
                        setState(() {
                          widget.cities = cities;
                        });
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      SoundService.instance.playTapDownSound();
                      await _mode.toggleMode();
                    },
                    child: Icon(
                      _mode.currentbool()
                          ? Icons.dark_mode_outlined
                          : Icons.dark_mode,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '$weatherMessage in $cityName',
                  textAlign: TextAlign.center,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
