import 'package:geolocator/geolocator.dart';

class BlockController {
  static const Map<String, List> blockCoordinates = {
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
            blockCoordinates[block]?[j][0][0],
            blockCoordinates[block]?[j][0][1],
            blockCoordinates[block]?[j][1][0],
            blockCoordinates[block]?[j][1][1],
            userPos.latitude,
            userPos.longitude)) {
          return block;
        }
      }
    }
    return "None";
  }
}
