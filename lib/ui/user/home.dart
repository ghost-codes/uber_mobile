import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_mobile/ui/widgets/primaryButton.dart';
import 'package:uber_mobile/utils/colors.dart';
import 'package:uber_mobile/utils/typography.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng _center = const LatLng(5.5271456532886365, -0.26302204548553937);
  late String _mapStyle;
  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    _mapStyle = await rootBundle.loadString('assets/txt/mapStyle.txt');
    mapController.setMapStyle(_mapStyle);
  }

  StreamController<LatLng> controller = StreamController();

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);

    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Uint8List? asset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      asset = await getBytesFromAsset("assets/imgs/economy-car.png", 70);
      Timer.periodic(const Duration(seconds: 1), (timer) {
        _center = LatLng(_center.latitude + 0.00005, _center.longitude);

        controller.sink.add(_center);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: UberColors.offWhite,
              child: StreamBuilder(
                  stream: controller.stream,
                  initialData: _center,
                  builder: (context, snap) {
                    return GoogleMap(
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      markers: {
                        Marker(
                          markerId: const MarkerId("asdfadsf"),
                          icon: asset == null
                              ? BitmapDescriptor.defaultMarker
                              : BitmapDescriptor.fromBytes(asset!),
                          position: snap.data!,
                        )
                      },
                      onMapCreated: onMapCreated,
                      initialCameraPosition: CameraPosition(target: _center, zoom: 16.0),
                    );
                  }),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              // top: 0,
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        height: 200,
                        width: width * 0.90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 0, 7, 16).withOpacity(0.9),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...["Economy", "Luxury", "Family"].map(
                              (index) => CarTypeWidget(
                                assetname: "assets/imgs/${index.toLowerCase()}-car.png",
                                name: index,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.90,
                        child: PrimaryButton(title: "Request Ride", onPressed: () {}),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CarTypeWidget extends StatelessWidget {
  const CarTypeWidget({
    required this.assetname,
    required this.name,
    super.key,
  });

  final String assetname;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 100,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [UberColors.secondary, UberColors.primary],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 0, child: SizedBox(width: 80, child: Center(child: Image.asset(assetname)))),
            ],
          ),
        ),
        const SizedBox(height: 10),
        UberText.paragraphRegular(name)
      ],
    );
  }
}
