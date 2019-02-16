import 'package:flutter_map/src/geo/latlng_bounds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';

void main() {
  var southWest = LatLng(32.075361, 34.789206);
  var southEast = LatLng(32.075361, 34.794656);
  var northWest = LatLng(32.093976, 34.789206);
  var northEast = LatLng(32.093976, 34.794656);

  List<LatLng> points = [southEast, southWest, northWest, northEast];

  var latLngBound = LatLngBounds.fromList(points);

  test("whenCreateFromListConstructor_CreateCorrectly", () {
    expect(latLngBound.isValid, true);

    expect(latLngBound.southEast, southEast);
    expect(latLngBound.southWest, southWest);
    expect(latLngBound.northEast, northEast);
    expect(latLngBound.northWest, northWest);

    expect(latLngBound.contains(LatLng(32.088366, 34.791688)), true);
    expect(latLngBound.contains(LatLng(0, 0)), false);
  });

  test("Create with null isValid correct", () {
    expect(LatLngBounds.fromList([null]).isValid, false);
  });

  test("Create with one object is valid correct", () {
    expect(LatLngBounds.fromList([LatLng(0, 0)]).isValid, false);
  });

  test("center is correct", () {
    expect(LatLngBounds(LatLng(55, -180), LatLng(65, -178)).center,
        LatLng(60, -179));
    expect(LatLngBounds(LatLng(48, 16), LatLng(49, 17)).center,
        LatLng(48.5, 16.5));
    //Not supported in this kind of implementation.
//    expect(LatLngBounds(LatLng(55, 179), LatLng(65, -169)).center(),
//        LatLng(60, -175));
  });
}
