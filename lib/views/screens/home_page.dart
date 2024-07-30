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

  Map<String, List> blockCoordinates = {
    "A Block": [
      [
        [28.450681795610162, 77.58363834137602],
        [28.45021147520149, 77.58447638801496],
      ]
    ],
    "B Block": [
      [
        [28.449901853357833, 77.58420970617611],
        [28.449429744662652, 77.58507266691117],
      ]
    ],
    "N Block": [
      [
        [28.448625753879796, 77.58271589857746],
        [28.449084838996665, 77.58454125544061],
      ],
      [
        [28.449499133610818, 77.58360735192923],
        [28.44923040215414, 77.58402760850936],
      ]
    ],
    "Sports Complex": [
      [
        [28.45019551330674, 77.58674809324677],
        [28.44987711084939, 77.58799174676149],
      ]
    ],
    "Football Field": [
      [
        [28.449525441885342, 77.58555922632736],
        [28.449456503894968, 77.58724798321825],
      ]
    ],
    "Mess": [
      [
        [28.45073450088025, 77.58577635218293],
        [28.450432237429567, 77.58681976269052],
      ]
    ],
    "N Block Ground": [
      [
        [28.448995799758805, 77.58239812014611],
        [28.44924223882021, 77.5837602955713]
      ]
    ]
  };

  bool isCoordinateInsideRectangle(double lat1, double lon1, double lat2,
      double lon2, double targetLat, double targetLon) {
    if ((lat1 <= targetLat && targetLat <= lat2 ||
            lat2 <= targetLat && targetLat <= lat1) &&
        (lon1 <= targetLon && targetLon <= lon2 ||
            lon2 <= targetLon && targetLon <= lon1)) {
      return true;
    } else {
      return false;
    }
  }

  String getBlockName(Position userPos) {
    for (var block in blockCoordinates.keys) {
      for (var j = 0; j < blockCoordinates[block]!.length; j++) {
        if (isCoordinateInsideRectangle(
            blockCoordinates[block]?[j][0][0] as double,
            blockCoordinates[block]?[j][0][1] as double,
            blockCoordinates[block]?[j][1][0] as double,
            blockCoordinates[block]?[j][1][1] as double,
            userPos.latitude,
            userPos.longitude)) {
          return block;
        }
      }
    }
    return "None";
  }

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
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                          ),
                        ),
                        Marker(
                            point: const LatLng(
                                28.451183291323957, 77.58494842787341),
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                            )),
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
