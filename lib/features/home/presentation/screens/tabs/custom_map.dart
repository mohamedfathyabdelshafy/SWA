import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:ui' as ui;

/// Widget واحد جاهز للاستخدام - يعرض خريطة بـ route
///
/// الاستخدام:
/// ```dart
/// MapRouteWidget(
///   routePoints: [
///     LatLng(30.0444, 31.2357),
///     LatLng(31.2001, 29.9187),
///   ],
/// )
/// ```
// class MapRouteWidget extends StatefulWidget {
//   /// قائمة نقاط المسار (LatLng)
//   final List<LatLng> routePoints;
//
//   /// لون الخط (default: أحمر)
//   final Color lineColor;
//
//   /// عرض الخط (default: 6)
//   final double lineWidth;
//
//   /// استخدام استايل grayscale (default: true)
//   final bool useGrayscale;
//
//   /// إظهار زر الموقع الحالي (default: false)
//   final bool showMyLocationButton;
//
//   /// إظهار أزرار الـ zoom (default: false)
//   final bool showZoomControls;
//
//   const MapRouteWidget({
//     super.key,
//     required this.routePoints,
//     this.lineColor = const Color(0xFFE74C3C),
//     this.lineWidth = 6,
//     this.useGrayscale = true,
//     this.showMyLocationButton = false,
//     this.showZoomControls = false,
//   });
//
//   @override
//   State<MapRouteWidget> createState() => _MapRouteWidgetState();
// }
//
// class _MapRouteWidgetState extends State<MapRouteWidget> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMap();
//   }
//
//   @override
//   void didUpdateWidget(MapRouteWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // لو القائمة اتغيرت، حدث الخريطة
//     if (oldWidget.routePoints != widget.routePoints) {
//       _initializeMap();
//     }
//   }
//
//   Future<void> _initializeMap() async {
//     if (widget.routePoints.isEmpty) {
//       setState(() => _isLoading = false);
//       return;
//     }
//
//     try {
//       // مسح البيانات القديمة
//       _markers.clear();
//       _polylines.clear();
//
//       // إنشاء الـ markers
//       final startIcon = await CustomMarkerHelper.createStartMarker(size: 60);
//       final endIcon = await CustomMarkerHelper.createEndMarker(size: 60);
//
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('start'),
//           position: widget.routePoints.first,
//           icon: startIcon,
//           anchor: const Offset(0.5, 0.5),
//         ),
//       );
//
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('end'),
//           position: widget.routePoints.last,
//           icon: endIcon,
//           anchor: const Offset(0.5, 0.5),
//         ),
//       );
//
//       // إنشاء الـ polyline
//       _polylines.add(
//         Polyline(
//           polylineId: const PolylineId('route'),
//           points: widget.routePoints,
//           color: widget.lineColor,
//           width: widget.lineWidth.toInt(),
//           startCap: Cap.roundCap,
//           endCap: Cap.roundCap,
//           jointType: JointType.round,
//         ),
//       );
//
//       setState(() => _isLoading = false);
//
//       // Auto-zoom للمسار
//       Future.delayed(const Duration(milliseconds: 500), _fitMapToRoute);
//     } catch (e) {
//       setState(() => _isLoading = false);
//       debugPrint('Error initializing map: $e');
//     }
//   }
//
//   Future<void> _fitMapToRoute() async {
//     if (widget.routePoints.isEmpty || !_controller.isCompleted) return;
//
//     try {
//       final controller = await _controller.future;
//
//       double minLat = widget.routePoints.first.latitude;
//       double maxLat = widget.routePoints.first.latitude;
//       double minLng = widget.routePoints.first.longitude;
//       double maxLng = widget.routePoints.first.longitude;
//
//       for (var point in widget.routePoints) {
//         if (point.latitude < minLat) minLat = point.latitude;
//         if (point.latitude > maxLat) maxLat = point.latitude;
//         if (point.longitude < minLng) minLng = point.longitude;
//         if (point.longitude > maxLng) maxLng = point.longitude;
//       }
//
//       // إضافة padding للـ bounds
//       final latPadding = (maxLat - minLat) * 0.1;
//       final lngPadding = (maxLng - minLng) * 0.1;
//
//       final bounds = LatLngBounds(
//         southwest: LatLng(minLat - latPadding, minLng - lngPadding),
//         northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
//       );
//
//       controller.animateCamera(
//         CameraUpdate.newLatLngBounds(bounds, 20),
//       );
//     } catch (e) {
//       debugPrint('Error fitting map to route: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.routePoints.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.map_outlined, size: 48, color: Colors.grey[400]),
//             const SizedBox(height: 8),
//             Text(
//               'لا توجد نقاط لعرضها',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Stack(
//       children: [
//         GoogleMap(
//           mapType: MapType.normal,
//           initialCameraPosition: CameraPosition(
//             target: widget.routePoints.first,
//             zoom: 10,
//           ),
//           markers: _markers,
//           polylines: _polylines,
//           onMapCreated: (GoogleMapController controller) {
//             if (!_controller.isCompleted) {
//               _controller.complete(controller);
//               // تطبيق الاستايل
//               if (widget.useGrayscale) {
//                 controller.setMapStyle(MapStyles.grayscale);
//               }
//             }
//           },
//           myLocationEnabled: false,
//           myLocationButtonEnabled: widget.showMyLocationButton,
//           zoomControlsEnabled: widget.showZoomControls,
//           mapToolbarEnabled: false,
//           compassEnabled: false,
//           rotateGesturesEnabled: true,
//           scrollGesturesEnabled: true,
//           tiltGesturesEnabled: false,
//           zoomGesturesEnabled: true,
//         ),
//
//         // Loading indicator
//         if (_isLoading)
//           Container(
//             color: Colors.white.withOpacity(0.8),
//             child: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

class MapRouteWidget extends StatefulWidget {
  /// قائمة نقاط المسار (LatLng)
  final List<LatLng> routePoints;

  /// لون الخط (default: أحمر)
  final Color lineColor;

  /// عرض الخط (default: 6)
  final double lineWidth;

  /// استخدام استايل grayscale (default: true)
  final bool useGrayscale;

  /// إظهار زر الموقع الحالي (default: false)
  final bool showMyLocationButton;

  /// إظهار أزرار الـ zoom (default: false)
  final bool showZoomControls;

  /// Google API Key (مطلوب فقط لو useDirections = true)
  final String? googleApiKey;

  /// استخدام Directions API للطرق الفعلية (default: false)
  final bool useDirections;

  const MapRouteWidget({
    super.key,
    required this.routePoints,
    this.lineColor = const Color(0xFFE74C3C),
    this.lineWidth = 6,
    this.useGrayscale = true,
    this.showMyLocationButton = false,
    this.showZoomControls = false,
    this.googleApiKey,
    this.useDirections = false,
  });

  @override
  State<MapRouteWidget> createState() => _MapRouteWidgetState();
}

class _MapRouteWidgetState extends State<MapRouteWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didUpdateWidget(MapRouteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لو القائمة اتغيرت، حدث الخريطة
    if (oldWidget.routePoints != widget.routePoints) {
      _initializeMap();
    }
  }

  Future<void> _initializeMap() async {
    if (_isDisposed) return;

    if (widget.routePoints.isEmpty) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      // مسح البيانات القديمة
      _markers.clear();
      _polylines.clear();

      // إنشاء الـ markers بالتوازي
      final results = await Future.wait([
        CustomMarkerHelper.createStartMarker(size: 60),
        CustomMarkerHelper.createEndMarker(size: 60),
      ]);

      if (_isDisposed) return;

      final startIcon = results[0];
      final endIcon = results[1];

      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: widget.routePoints.first,
          icon: startIcon,
          anchor: const Offset(0.5, 0.5),
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: widget.routePoints.last,
          icon: endIcon,
          anchor: const Offset(0.5, 0.5),
        ),
      );

      // الحصول على نقاط المسار
      List<LatLng> routePoints = widget.routePoints;

      // لو useDirections = true، استخدم Directions API
      if (widget.useDirections &&
          widget.googleApiKey != null &&
          widget.routePoints.length >= 2) {
        final directions = await _getDirections();
        if (directions.isNotEmpty) {
          routePoints = directions;
        }
      }

      if (_isDisposed) return;

      // إنشاء الـ polyline
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          color: widget.lineColor,
          width: widget.lineWidth.toInt(),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );

      if (mounted && !_isDisposed) {
        setState(() => _isLoading = false);

        // Auto-zoom للمسار
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!_isDisposed) _fitMapToRoute();
        });
      }
    } catch (e) {
      debugPrint('Error initializing map: $e');
      if (mounted && !_isDisposed) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// الحصول على المسار باستخدام Directions API
  Future<List<LatLng>> _getDirections() async {
    if (widget.routePoints.length < 2 || widget.googleApiKey == null) {
      return widget.routePoints;
    }

    try {
      PolylinePoints polylinePoints =
          PolylinePoints(apiKey: widget.googleApiKey.toString());

      // لو في نقاط وسطية (waypoints)
      List<PolylineWayPoint>? waypoints;
      if (widget.routePoints.length > 2) {
        waypoints = widget.routePoints
            .sublist(1, widget.routePoints.length - 1)
            .map((point) => PolylineWayPoint(
                  location: '${point.latitude},${point.longitude}',
                ))
            .toList();
      }

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            widget.routePoints.first.latitude,
            widget.routePoints.first.longitude,
          ),
          destination: PointLatLng(
            widget.routePoints.last.latitude,
            widget.routePoints.last.longitude,
          ),
          mode: TravelMode.driving,
          wayPoints: waypoints ?? [],
        ),
      );

      if (result.points.isNotEmpty) {
        return result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      } else {
        debugPrint('Polyline error: ${result.errorMessage}');
        return widget.routePoints; // fallback
      }
    } catch (e) {
      debugPrint('Error getting directions: $e');
      return widget.routePoints; // fallback
    }
  }

  Future<void> _fitMapToRoute() async {
    if (_isDisposed || widget.routePoints.isEmpty || _mapController == null) {
      return;
    }

    try {
      double minLat = widget.routePoints.first.latitude;
      double maxLat = widget.routePoints.first.latitude;
      double minLng = widget.routePoints.first.longitude;
      double maxLng = widget.routePoints.first.longitude;

      for (var point in widget.routePoints) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      // إضافة padding للـ bounds
      final latPadding = (maxLat - minLat) * 0.1;
      final lngPadding = (maxLng - minLng) * 0.1;

      final bounds = LatLngBounds(
        southwest: LatLng(minLat - latPadding, minLng - lngPadding),
        northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
      );

      if (!_isDisposed && _mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 20),
        );
      }
    } catch (e) {
      debugPrint('Error fitting map to route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.routePoints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'لا توجد نقاط لعرضها',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: widget.routePoints.first,
            zoom: 10,
          ),
          markers: _markers,
          polylines: _polylines,
          onMapCreated: (GoogleMapController controller) {
            if (!_isDisposed) {
              _mapController = controller;

              // تطبيق الاستايل
              if (widget.useGrayscale) {
                controller.setMapStyle(MapStyles.grayscale);
              }
            }
          },
          myLocationEnabled: false,
          myLocationButtonEnabled: widget.showMyLocationButton,
          zoomControlsEnabled: widget.showZoomControls,
          mapToolbarEnabled: false,
          compassEnabled: false,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: true,
        ),

        // Loading indicator
        if (_isLoading)
          Container(
            color: Colors.white.withOpacity(0.8),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }
}

/// ملف الـ Map Styles
///
/// يحتوي على أنماط مختلفة للخريطة (Grayscale, Dark, Light, etc.)

class MapStyles {
  /// استايل Grayscale (رمادي) - زي الصورة
  static const String grayscale = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#f5f5f5"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#f5f5f5"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#bdbdbd"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#eeeeee"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [{"color": "#e5e5e5"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#ffffff"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#dadada"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    },
    {
      "featureType": "transit.line",
      "elementType": "geometry",
      "stylers": [{"color": "#e5e5e5"}]
    },
    {
      "featureType": "transit.station",
      "elementType": "geometry",
      "stylers": [{"color": "#eeeeee"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#c9c9c9"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    }
  ]
  ''';

  /// استايل Dark Mode (وضع داكن)
  static const String dark = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#212121"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#212121"}]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#bdbdbd"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [{"color": "#181818"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#2c2c2c"}]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#8a8a8a"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [{"color": "#373737"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#3c3c3c"}]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [{"color": "#4e4e4e"}]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#000000"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#3d3d3d"}]
    }
  ]
  ''';

  /// استايل Light (وضع فاتح - default)
  static const String light = '''
  [
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#e9e9e9"}, {"lightness": 17}]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [{"color": "#f5f5f5"}, {"lightness": 20}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#ffffff"}, {"lightness": 17}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#ffffff"}, {"lightness": 29}, {"weight": 0.2}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [{"color": "#ffffff"}, {"lightness": 18}]
    },
    {
      "featureType": "road.local",
      "elementType": "geometry",
      "stylers": [{"color": "#ffffff"}, {"lightness": 16}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#f5f5f5"}, {"lightness": 21}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"visibility": "on"}, {"color": "#ffffff"}, {"lightness": 16}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"saturation": 36}, {"color": "#333333"}, {"lightness": 40}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit",
      "elementType": "geometry",
      "stylers": [{"color": "#f2f2f2"}, {"lightness": 19}]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#fefefe"}, {"lightness": 20}]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#fefefe"}, {"lightness": 17}, {"weight": 1.2}]
    }
  ]
  ''';

  /// استايل Retro (قديم)
  static const String retro = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#ebe3cd"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#523735"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#f5f1e6"}]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#c9b2a6"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#dcd2be"}]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#ae9e90"}]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "geometry",
      "stylers": [{"color": "#dfd2ae"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#dfd2ae"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#93817c"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#a5b076"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#447530"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#f5f1e6"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [{"color": "#fdfcf8"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#f8c967"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#e9bc62"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#b9d3c2"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#92998d"}]
    }
  ]
  ''';
}

/// Helper class لإنشاء custom markers على شكل دوائر
class CustomMarkerHelper {
  /// إنشاء marker على شكل دائرة مع outline
  ///
  /// [fillColor] - لون الدائرة الداخلية
  /// [size] - حجم الـ marker (default: 80)
  /// [borderColor] - لون الحدود الخارجية (default: رمادي)
  /// [borderWidth] - عرض الحدود (default: 3)
  static Future<BitmapDescriptor> createCircleMarker({
    required Color fillColor,
    double size = 80,
    Color? borderColor,
    double borderWidth = 3,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // رسم الـ outer circle (الخلفية البيضاء)
    final outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, outerPaint);

    // رسم الـ border (الحدود)
    final borderPaint = Paint()
      ..color = borderColor ?? Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, borderPaint);

    // رسم الـ inner circle (الدائرة الملونة)
    final innerPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 8, innerPaint);

    // تحويل لـ image
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(buffer);
  }

  /// إنشاء marker للبداية (دائرة بيضاء)
  static Future<BitmapDescriptor> createStartMarker({double size = 80}) {
    return createCircleMarker(
      fillColor: Colors.white,
      size: size,
    );
  }

  /// إنشاء marker للنهاية (دائرة حمراء)
  static Future<BitmapDescriptor> createEndMarker({double size = 80}) {
    return createCircleMarker(
      fillColor: const Color(0xFFE74C3C),
      size: size,
    );
  }

  /// إنشاء marker مع نص بداخله
  static Future<BitmapDescriptor> createMarkerWithText({
    required String text,
    Color fillColor = Colors.blue,
    Color textColor = Colors.white,
    double size = 100,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // رسم الدائرة
    final outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, outerPaint);

    final borderPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, borderPaint);

    final innerPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 8, innerPaint);

    // إضافة النص
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: size / 3,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(buffer);
  }

  /// إنشاء marker بأيقونة (icon)
  static Future<BitmapDescriptor> createMarkerWithIcon({
    required IconData icon,
    Color fillColor = Colors.blue,
    Color iconColor = Colors.white,
    double size = 100,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // رسم الدائرة
    final outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, outerPaint);

    final borderPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, borderPaint);

    final innerPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 8, innerPaint);

    // رسم الأيقونة
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          fontSize: size / 2.5,
          color: iconColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(buffer);
  }
}
