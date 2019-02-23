import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/src/geo/latlng_bounds.dart';
import 'package:flutter_map/src/layer/layer.dart';
import 'package:flutter_map/src/layer/marker_layer.dart';
import 'package:flutter_map/src/map/map.dart';

class MarkerClusterLayerOptions extends LayerOptions {
  final MarkerCluster cluster;
  MarkerClusterLayerOptions({this.cluster, rebuild}) : super(rebuild: rebuild);
}

class MarkerClusterStyle {
  final Color color;
  final Color textColor;

  MarkerClusterStyle(this.color, this.textColor);
}

class MarkerCluster {
  final List<Marker> markers;
  final double width;
  final double height;
  WidgetBuilder builder;
  MarkerClusterStyle style;
  final ClusterOptions options;

  MarkerCluster(this.markers, this.options,
      {this.width = 30.0, this.height = 30.0, this.style, this.builder});
}

class ClusterOptions {
  var isClustering;

  bool shouldCluster(MarkerClusterLayerOptions options, MapState mapState) {
    return isClustering;
  }

  ClusterOptions({this.isClustering = true});
}

class MarkerClusterLayer extends StatelessWidget {
  final MarkerClusterLayerOptions markerOpts;
  final MapState map;
  final Stream<Null> stream;

  const MarkerClusterLayer(this.markerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          var point = LatLngBounds.fromList(this
                  .markerOpts
                  .cluster
                  .markers
                  .map((marker) => marker.point)
                  .toList())
              .center;

          if (!map.bounds.contains(point)) {
            return new Stack();
          }

          var pos = map.project(point);
          pos = pos.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
              map.getPixelOrigin();
          var pixelPosX = (pos.x - (markerOpts.cluster.width)).toDouble();
          var pixelPosY = (pos.y - (markerOpts.cluster.height)).toDouble();

          var style = this.markerOpts.cluster.style;
          return new Container(
              child: new Positioned(
            width: markerOpts.cluster.width,
            height: markerOpts.cluster.height,
            left: pixelPosX,
            top: pixelPosY,
            child: markerOpts.cluster.builder != null
                ? markerOpts.cluster.builder(context)
                : new Stack(
                    children: [
                      new Container(
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                            shape: CircleBorder(), color: style.color),
                        child: new Text(
                          "${markerOpts.cluster.markers.length}",
                          style: TextStyle(color: style.textColor),
                        ),
                      )
                    ],
                  ),
          ));
        });
  }
}
