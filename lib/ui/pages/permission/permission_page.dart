import 'package:f_gps_tracker/ui/controllers/gps.dart';
import 'package:f_gps_tracker/ui/controllers/location.dart';
import 'package:f_gps_tracker/ui/pages/content/content_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _LocationState();
}

class _LocationState extends State<PermissionPage> {
  late GpsController controller;
  late Future<LocationPermission> _permissionStatus;

  @override
  void initState() {
    super.initState();
    controller = Get.find();
    // TODO: Asigna a _permissionStatus el futuro que obtiene el estado de los permisos.;
    _permissionStatus = controller.permissionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(
              child: Text("GPS Tracker",
                  style: TextStyle(fontWeight: FontWeight.w700))),
        ),
        body: FutureBuilder<LocationPermission>(
          future: _permissionStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final status = snapshot.data!;
              if (status == LocationPermission.always ||
                  status == LocationPermission.whileInUse) {
                Get.find<LocationController>().initialize().then(
                      (value) => WidgetsBinding.instance.addPostFrameCallback(
                        (_) => Get.offAll(() => ContentPage()),
                      ),
                    );
                /* TODO: Busca el controlador de ubicacion [LocationController] con [Get.find],
                 inicializalo [initialize] y cuando el futuro se complete [then] usando [WidgetsBinding.instance.addPostFrameCallback]
                 navega usando [Get.offAll] a [ContentPage] */

                // TODO: Mientras el futuro se completa muestra un CircularProgressIndicator
                return Center(child: CircularProgressIndicator());
              } else if (status == LocationPermission.unableToDetermine ||
                  status == LocationPermission.denied) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
                        child: Image(
                            image: NetworkImage(
                                'https://cdni.iconscout.com/illustration/premium/thumb/location-map-3075574-2607632.png')),
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            // TODO: Actualiza el futuro _permissionStatus con requestPermission
                            _permissionStatus = controller.requestPermission();
                            // TODO: y setState para que el FutureBuilder vuelva a renderizarse.
                          });
                        },
                        icon: Icon(Icons.task_alt, color: Colors.black),
                        label: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("OPRIMA PARA DAR PERMISOS",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
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
                    ),
                  ],
                );
              } else {
                // TODO: Muestra un texto cuando el usuario a denegado el permiso permanentemente
                return Center(
                  child: Text('No se han habilitado los permisos'),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              // TODO: Muestra un texto con el error si ocurre.
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              // TODO: Mientras el futuro se completa muestra un CircularProgressIndicator
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
