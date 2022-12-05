import 'package:climate/services/weather.dart';
import 'package:climate/services/feedback.dart';
import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'city_screen.dart';

class favorite_city_screen extends StatefulWidget {
  final List<String> cities;
  favorite_city_screen(this.cities);
  @override
  _favorite_city_screen createState() => _favorite_city_screen();
}

class _favorite_city_screen extends State<favorite_city_screen> {
  List<Widget> listWidget = [];

  void initState() {
    super.initState();

    addPreviousCities();
  }

  void addPreviousCities() {
    listWidget.add(backButton());
    listWidget.add(addButton());
    List<String> data = widget.cities;
    data.forEach((element) {
      listWidget.add(itemCard(element));
    });
  }

  Widget itemCard(element) {
    return SizedBox(
      width: 600,
      height: 100,
      child: Card(
        elevation: 0,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, //Center Row contents horizontally,
          crossAxisAlignment:
              CrossAxisAlignment.center, //Center Row contents vertically,
          children: [
            FavoriteItem(element),
            TextButton(
                onPressed: () {
                  SoundService.instance.playTapDownSound();
                  deleteItem(element);
                },
                child: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }

  Widget backButton() {
    return TextButton(
      onPressed: () async {
        //await SoundService.instance.playTapDownSound();
        SoundService.instance.playTapDownSound();
        Navigator.pop(context, widget.cities);
      },
      child: Text(
        'Back to main menu',
        style: kButtonTextStyle,
      ),
    );
  }

  Widget addButton() {
    return TextButton(
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
            newItem(typedName);
          }
        },
        child: Text("Add new favorite item"));
  }

  void newItem(typedName) {
    setState(() {
      listWidget.add(itemCard(typedName));
      widget.cities.add(typedName);
    });
  }

  void deleteItem(typedName) {
    setState(() {
      widget.cities.remove(typedName);
      listWidget.clear();
      addPreviousCities();
    });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: listWidget,
        )
      ],
    ));
  }
}

class FavoriteItem extends StatefulWidget {
  final String cityName;
  FavoriteItem(this.cityName);

  _favoriteItem createState() => _favoriteItem();
}

class _favoriteItem extends State<FavoriteItem> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String weatherIcon;
  String cityName;
  String weatherMessage;
  int timezone;
  DateTime time;
  int hour;
  int minute;

  void initState() {
    super.initState();
    cityName = widget.cityName;

    start();
  }

  void start() async {
    var weatherData = await weather.getCityWeather(cityName);
    updateUI(weatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = '';
        time = DateTime.now();

        hour = 0;
        minute = 0;
        return;
      }
      timezone = weatherData['timezone'];
      time = DateTime.now().add(Duration(
          seconds: timezone - DateTime.now().timeZoneOffset.inSeconds));

      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
      hour = time.hour;
      minute = time.minute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        widget.cityName + ' is $temperature degrees C $hour:$minute',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      TextButton(
          onPressed: () async {
            SoundService.instance.playTapDownSound();
            var weatherData = await weather.getCityWeather(cityName);
            updateUI(weatherData);
          },
          child: Icon(Icons.refresh)),
    ]);
  }
}
