import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:misiontic_template/domain/use_case/controllers/notifications.dart';
import 'package:misiontic_template/domain/use_case/location_management.dart';
import 'package:misiontic_template/domain/use_case/notification_management.dart';
import 'package:misiontic_template/ui/app.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController notificationController =
      Get.put(NotificationController());
  await notificationController.initialize();
  notificationController.createChannel(
      id: 'user-location',
      name: 'User Location',
      description: 'My Location...');
  await Workmanager().initialize(
    updatePositionInBackground,
    isInDebugMode: false,
  );
  await Workmanager().registerPeriodicTask(
      "1",
      "locationPeriodicTask",
    );
  runApp(const App());
}

void updatePositionInBackground() async {
  final manager = LocationManager();
  final _manager = NotificationManager();
  Workmanager().executeTask((task, inputData) async {
    await _manager.initialize();
    final _channel = _manager.createChannel(
        id: 'user-location',
        name: 'User Location',
        description: 'My Location...');
    final position = await manager.getCurrentLocation();
    _manager.showNotification(
        channel: _channel,
        title: 'Tu ubicación es...',
        body: 'Latitud ${position.latitude} - Longitud: ${position.longitude}');
    return Future.value(true);
  });
}
