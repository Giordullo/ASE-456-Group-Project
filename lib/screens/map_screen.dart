import 'package:climate/main.dart';
import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:climate/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../services/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng pos;
  Location location = Location();

  @override
  void initState() {
    super.initState();

    location.getCurrentLocation().then((p){
      setState(() {
        pos = LatLng(location.latitude, location.longitude);
        print(pos.latitude);
        print(pos.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (location.longitude == null) {
      return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text("Map Loading..."),
          ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Map"),
      ),
      body: FlutterMap(
          options: MapOptions(center: pos),
          children: [
            TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
            CircleLayer(
                circles: [
                  CircleMarker(point: pos, radius: 12, color: Colors.black),
                  CircleMarker(point: pos, radius: 10, color: Colors.red)
                ]
            )
          ]
      )
    );
  }
}
