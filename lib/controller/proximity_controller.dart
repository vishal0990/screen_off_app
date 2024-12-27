import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proximity_screen_lock_android/proximity_screen_lock_android.dart';
import 'package:vibration/vibration.dart';

class ProximityController extends GetxController with WidgetsBindingObserver {
  final ProximityScreenLockAndroid _proximityScreenLock =
      ProximityScreenLockAndroid();
  var isActive = false.obs;
  var isSupported = false.obs;

  var isScreenLocked = false.obs; // Observable to track screen lock status

  RxString screenState = 'Unknown'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    checkProximitySupport();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    // Remove observer when controller is disposed
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle the lifecycle state changes
    if (state == AppLifecycleState.resumed) {
      // App has resumed, screen is likely ON
      screenState.value = 'Screen ON (App Resumed)';
    } else if (state == AppLifecycleState.paused) {
      // App is paused, screen is likely OFF
      screenState.value = 'Screen OFF (App Paused)';
//      HapticFeedback.heavyImpact();
      _vibrateDevice();
    } else if (state == AppLifecycleState.inactive) {
      // App is inactive, for example during a phone call or notification
      screenState.value = 'Screen INACTIVE (App Inactive)';
    } else if (state == AppLifecycleState.detached) {
      // App is detached (removed from memory)
      screenState.value = 'Screen DETACHED (App Detached)';
    }
  }

  // Method to trigger vibration
  void _vibrateDevice() {
    Vibration.vibrate(duration: 1000, amplitude: 128);
  }

  Future<void> checkProximitySupport() async {
    isSupported.value = await _proximityScreenLock.isProximityLockSupported();
  }

  Future<void> toggleProximitySensor() async {
    isActive.value = !isActive.value;
    await _proximityScreenLock.setActive(isActive.value);
  }
}
