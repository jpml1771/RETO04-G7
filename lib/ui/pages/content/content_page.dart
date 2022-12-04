import 'package:f_gps_tracker/domain/models/location.dart';
import 'package:f_gps_tracker/ui/controllers/gps.dart';
import 'package:f_gps_tracker/ui/controllers/location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentPage extends GetView<LocationController> {
  late final GpsController gpsController = Get.find();

  ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("GPS Tracker",
                style: TextStyle(fontWeight: FontWeight.w700))),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.5, 0.75],
            colors: [
              Colors.teal,
              Colors.blue,
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder(
            future: controller.getAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
                      child: Image(
                        image: NetworkImage(
                            'https://cdni.iconscout.com/illustration/premium/thumb/location-map-3075574-2607632.png'),
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              // TODO: 1. Obten la ubicacion actual con gpsController.currentLocation
                              var loc = await gpsController.currentLocation;
                              // TODO: 2. Obten la precision de la lectura con gpsController.locationAccuracy.
                              var pres = await gpsController.locationAccuracy;
                              // TODO: 3. Crea un objeto [TrackedLocation] con fecha actual [DateTime.now] y la precisio como texto [accuracy.name]
                              print(pres.toString());
                              var Trackedlocation = TrackedLocation(
                                  latitude: loc.latitude,
                                  longitude: loc.longitude,
                                  precision: pres.toString(),
                                  timestamp: DateTime.now());
                              // TODO: 4. con el [controller] guarda ese objeto [saveLocation]
                              controller.saveLocation(
                                  location: Trackedlocation);
                            },
                            icon: Icon(Icons.add_location, color: Colors.black),
                            label: Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Text("Registrar Ubicacion",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              // TODO: elimina todas las ubicaciones usando el controlador [deleteAll]
                              await controller.deleteAll();
                            },
                            icon: Icon(Icons.delete, color: Colors.black),
                            label: Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: Text("Eliminar Todos",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => controller.locations.isNotEmpty
                            ? ListView.separated(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: controller.locations.length,
                                itemBuilder: (context, index) {
                                  final location = controller.locations[index];
                                  return Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListTile(
                                        isThreeLine: true,
                                        leading: Icon(
                                          Icons.gps_fixed_rounded,
                                          color: Colors.black,
                                        ),
                                        title: Padding(
                                          padding: EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                              '${location.latitude}, ${location.longitude}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        subtitle: Text(
                                            'Fecha: ${location.timestamp.toIso8601String()}\n${location.precision.toUpperCase()}',
                                            style: TextStyle(fontSize: 12)),
                                        trailing: IconButton(
                                          onPressed: () {
                                            // TODO: elimina la ubicacion [location] usando el controlador [deleteLocation]
                                            controller.deleteLocation(
                                                location: location);
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8.0),
                              )
                            : Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: Text(
                                    'OPRIME REGISTRAR UBICACIÓN PARA INCIAR',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                              ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
