class KMLMakers {
  //Lg logo to the left screen
  static String screenOverlayImage(String imageUrl, double x, double y) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2">
        <ScreenOverlay>
          <name>LG Logo</name>
          <Icon><href>$imageUrl</href></Icon>
          <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
          <screenXY x="$x" y="$y" xunits="fraction" yunits="fraction"/>
          <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
          <size x="0.3" y="0.3" xunits="fraction" yunits="fraction"/>
        </ScreenOverlay>
      </kml>''';
        }

  static String lookAt(double lat, double lon, double range, double tilt, double heading) {
    return '<LookAt><longitude>$lon</longitude><latitude>$lat</latitude><range>$range</range><tilt>$tilt</tilt><heading>$heading</heading><altitudeMode>relativeToGround</altitudeMode></LookAt>';
  }

  static String pyramid() {
    //lat is the center
    double lat = 23.2156;
    double lon = 72.6369;
    //dimension
    double size = 0.003;
    double height = 200;

    String c1 = "${lon - size},${lat - size},0";
    String c2 = "${lon + size},${lat - size},0";
    String c3 = "${lon + size},${lat + size},0";
    String c4 = "${lon - size},${lat + size},0";
    String peak = "$lon,$lat,$height";

    return '''<?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2">
      <Document>
        <name>True 3D Pyramid</name>
        <Placemark><name>Face 1</name><Style><PolyStyle><color>ff00C4DE</color><fill>1</fill><outline>0</outline></PolyStyle></Style><Polygon><altitudeMode>relativeToGround</altitudeMode><outerBoundaryIs><LinearRing><coordinates>$c1 $c2 $peak $c1</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>
        <Placemark><name>Face 2</name><Style><PolyStyle><color>ff009CB0</color><fill>1</fill><outline>0</outline></PolyStyle></Style><Polygon><altitudeMode>relativeToGround</altitudeMode><outerBoundaryIs><LinearRing><coordinates>$c2 $c3 $peak $c2</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>
        <Placemark><name>Face 3</name><Style><PolyStyle><color>ff00C4DE</color><fill>1</fill><outline>0</outline></PolyStyle></Style><Polygon><altitudeMode>relativeToGround</altitudeMode><outerBoundaryIs><LinearRing><coordinates>$c3 $c4 $peak $c3</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>
        <Placemark><name>Face 4</name><Style><PolyStyle><color>ff009CB0</color><fill>1</fill><outline>0</outline></PolyStyle></Style><Polygon><altitudeMode>relativeToGround</altitudeMode><outerBoundaryIs><LinearRing><coordinates>$c4 $c1 $peak $c4</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>
      </Document>
      </kml>''';
        }
      }