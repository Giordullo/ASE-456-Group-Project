import 'package:climate/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_daily.dart';

class WeatherForecastScreen extends StatelessWidget {
  final List<Daily> list;
  final String city;

  WeatherForecastScreen(this.list, this.city);

  String getDay(final day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    final x = DateFormat('EEE').format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    // The 'builder' named constructor builds a list of widgets
    // by taking the 'myList' list as data source.
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/location_background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: SafeArea(
          child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 50.0,
              ),
            ),
          ),
          Container(
            height: 600,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '${city} : 7 Day Forecast',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.none),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                      itemCount: 7,
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      getDay(list[index].date),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 70,
                                      height: 30,
                                      child: Text(
                                        WeatherModel().getWeatherIcon(
                                            list[index].weather[0].id),
                                      )),
                                  Text(
                                    '${list[index].temp.max}°/${list[index].temp.min}°',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        decoration: TextDecoration.none),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
