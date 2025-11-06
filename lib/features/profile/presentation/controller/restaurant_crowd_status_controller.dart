import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcovert/config/api/api_end_point.dart';
import 'package:tcovert/services/api/api_service.dart';
import 'package:tcovert/services/storage/storage_keys.dart';
import 'package:tcovert/services/storage/storage_services.dart';
import 'package:tcovert/utils/app_utils.dart';
import 'package:tcovert/features/home/presentation/controller/home_controller.dart';

class RestaurantCrowdStatusController extends GetxController {
  // Observable variables
  var selectedStatus = Rxn<String>();
  var isLoading = false.obs;

  final List<Map<String, dynamic>> statusOptions = [
    {'label': 'Normal', 'value': 'normal', 'color': const Color(0xFF00BCD4)},
    {'label': 'High', 'value': 'high', 'color': const Color(0xFF4CAF50)},
    {
      'label': 'Overload',
      'value': 'overloaded',
      'color': const Color(0xFFB71C1C),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Load from local storage
    selectedStatus.value = LocalStorage.restaurantCrowdStatus;
  }

  // Select status method
  void selectStatus(String status) {
    selectedStatus.value = status;
  }

  // Get label from value
  String? getStatusLabel(String? value) {
    if (value == null) return null;
    final option = statusOptions.firstWhere(
      (opt) => opt['value'] == value,
      orElse: () => {},
    );
    return option['label'];
  }

  // Save crowd status to API
  Future<void> saveCrowdStatus() async {
    if (selectedStatus.value == null) {
      Utils.errorSnackBar('Error', 'Please select a status');
      return;
    }

    try {
      isLoading.value = true;
      Map<String, dynamic> body = {
        "restaurant_crowd_status": selectedStatus.value,
      };
      var response = await ApiService.patch(
        ApiEndPoint.user,
        body: body,
        header: {'Authorization': 'Bearer ${LocalStorage.token}'},
      );
      if (response.statusCode == 200) {
        // Update local storage
        LocalStorage.restaurantCrowdStatus = selectedStatus.value!;
        await LocalStorage.setString(
          LocalStorageKeys.restaurantCrowdStatus,
          selectedStatus.value!,
        );

        // Refresh HomeController to get latest data
        try {
          final homeController = Get.find<HomeController>();
          await homeController.fetchNearbyBusinesses();
        } catch (e) {
          print('HomeController not found or error refreshing: $e');
        }

        final label = getStatusLabel(selectedStatus.value);
        Utils.successSnackBar('Success', 'Status saved: $label');
        Get.back();
      } else {
        Utils.errorSnackBar(response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(e.toString(), e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
