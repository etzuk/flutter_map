import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class MarkerClusterPage extends StatefulWidget {
  static const String route = '/marker_clusters';
  @override
  MarkerClusterPageState createState() {
    return new MarkerClusterPageState();
  }
}

class MarkerClusterPageState extends State<MarkerClusterPage> {

  var showCluster = true;

  Widget build(BuildContext context) {
    var markers = <Marker>[
      new Marker(
        width: 80.0,
        height: 80.0,
        point: new LatLng(51.5, -0.09),
        builder: (ctx) => new Container(
          child: new FlutterLogo(),
        ),
      ),
      new Marker(
        width: 80.0,
        height: 80.0,
        point: new LatLng(53.3498, -6.2603),
        builder: (ctx) => new Container(
          child: new FlutterLogo(
            colors: Colors.green,
          ),
        ),
      ),
      new Marker(
        width: 80.0,
        height: 80.0,
        point: new LatLng(48.8566, 2.3522),
        builder: (ctx) => new Container(
          child: new FlutterLogo(colors: Colors.purple),
        ),
      ),
    ];

    var markerCluster = MarkerCluster(markers, ClusterZoomOptions(),
        style:
        new MarkerClusterStyle(Colors.amber, Colors.black));

    return new Scaffold(
        appBar: new AppBar(title: new Text("Markers Cluster")),
        drawer: buildDrawer(context, MarkerClusterPage.route),
        body: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            children: [
              new Padding(
                padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Column(
                  children: <Widget>[
                    new Text("This is a map that is showing a marker cluster example."),
                    new MaterialButton(
                      child: new Text("show cluster"),
                      onPressed: () { setState(() {
                        showCluster = !showCluster;
                      }); }),
                  ],
                ),
              ),
              new Flexible(
                child: new FlutterMap(
                  options: new MapOptions(
                    center: new LatLng(51.5, -0.09),
                    zoom: 5.0,
                  ),
                  layers: [
                    new TileLayerOptions(
                        urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    new MarkerClusterLayerOptions(cluster: markerCluster),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class ClusterZoomOptions extends ClusterOptions {
  @override
  bool shouldCluster(MarkerClusterLayerOptions options, MapState mapState) {
    return mapState.zoom < 4;
  }
}