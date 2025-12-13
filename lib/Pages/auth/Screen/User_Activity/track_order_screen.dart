import 'package:fast_food_app/Core/Provider/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:provider/provider.dart';

class TrackOrderScreen extends StatelessWidget {
  final OrderModel order;
  const TrackOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackingProvider()..init(order),
      child: Scaffold(
        appBar: AppBar(title: const Text("Theo dõi đơn hàng")),
        body: Consumer<TrackingProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: provider.shopLocation,
                    zoom: 14,
                  ),
                  markers: provider.markers,
                  polylines: provider.polylines,
                  onMapCreated: (GoogleMapController controller) {
                    provider.setMapController(controller);
                  },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      provider.findDriver();
                    },
                    label: const Text('Tìm tài xế'),
                    icon: const Icon(Icons.directions_bike),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}