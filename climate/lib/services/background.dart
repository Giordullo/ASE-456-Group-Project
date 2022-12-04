import 'package:workmanager/workmanager.dart';
import 'package:climate/services/weather.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Background {
  static Future<void> RunLocalNotifications() async {
    int temp = await GetTemp();
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              enableVibration: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Public,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple),
        ],
        debug: true);
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: "alerts",
            title: "Current Weather",
            body: "It is currently $temp°",
            notificationLayout: NotificationLayout.Default));
  }
}

Future<int> GetTemp() async {
  WeatherModel weather = WeatherModel();
  dynamic weatherData = await weather.getLocationWeather();
  return weatherData['main']['temp'].toInt();
}
