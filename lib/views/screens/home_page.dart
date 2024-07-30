import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? center;
  final styleUrl =
      "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png";
  final apiKey = "e2421755-eb2a-4461-b7fe-29a8a7b5aaec";

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  void initState() {
    super.initState();
    determinePosition().then((value) {
      setState(() {
        center = LatLng(value.latitude, value.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: center == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FlutterMap(
                options: MapOptions(
                    initialCenter: center!,
                    // center: LatLng(59.438484, 24.742595),
                    initialZoom: 14,
                    keepAlive: true),
                children: [
                  TileLayer(
                    urlTemplate: "$styleUrl?api_key={api_key}",
                    additionalOptions: {"api_key": apiKey},
                    maxZoom: 20,
                    maxNativeZoom: 20,
                  ),
                  CurrentLocationLayer(
                      alignPositionOnUpdate: AlignOnUpdate.always,
                      alignDirectionOnUpdate: AlignOnUpdate.always,
                      style: LocationMarkerStyle(
                        markerSize: const Size(30, 30),
                        markerDirection: MarkerDirection.heading,
                      )),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 45,
                      size: const Size(40, 40),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(50),
                      maxZoom: 15,
                      markers: [
                        Marker(
                          point: const LatLng(
                              30.65426548694503, 76.85826072220257),
                          child: Icon(Icons.location_pin),
                        ),
                        Marker(
                            point: const LatLng(
                                36.15720618462996, -86.77819820373395),
                            child: Icon(Icons.location_pin)),
                      ],
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            determinePosition().then((value) {
              setState(() {
                center = LatLng(value.latitude, value.longitude);
              });
            });
          },
          child: const Icon(Icons.my_location),
        ));
  }
}
