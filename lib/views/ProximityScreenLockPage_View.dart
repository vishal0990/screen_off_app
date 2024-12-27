import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/proximity_controller.dart';

class ProximityScreenLockPage extends StatelessWidget {
  const ProximityScreenLockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProximityController controller = Get.put(ProximityController());
    print(controller.screenState.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Off'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        /*    Obx(() {
              return Text(
                'Screen State: ${controller.screenState.value}',
                style: TextStyle(fontSize: 24),
              );
            }),*/
            Obx(() => Text(
                  controller.isSupported.value ? "Supported" : "Not Supported",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
            Obx(() => TextButton(
                  onPressed: controller.toggleProximitySensor,
                  child: Text(
                    'Proximity Lock is ${controller.isActive.value ? "Activate" : "De-activate"}',
                    style: TextStyle(
                      color: controller.isActive.value
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
