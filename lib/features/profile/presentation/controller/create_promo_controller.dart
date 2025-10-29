import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/api/api_end_point.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../data/model/promo_request_model.dart';
import '../../data/model/promo_response_model.dart';

class CreatePromoController extends GetxController {
  // Form controllers
  final TextEditingController promoTitleController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State variables
  RxBool isLoading = false.obs;
  RxBool generateQRCode = true.obs;
  RxBool generatePromoCode = false.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  PromoResponseModel? promoResponseModel;

  @override
  void onClose() {
    promoTitleController.dispose();
    discountController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  /// Toggle QR Code generation
  void toggleQRCode(bool value) {
    generateQRCode.value = value;
  }

  /// Toggle Promo Code generation
  void togglePromoCode(bool value) {
    generatePromoCode.value = value;
  }

  /// Select date
  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.secondary,
              onPrimary: AppColors.white,
              surface: AppColors.textfieldColor,
              onSurface: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStartDate) {
        startDate.value = picked;
        startDateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      } else {
        endDate.value = picked;
        endDateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      }
    }
  }

  /// Validate and submit form
  Future<void> handleCreatePromo() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Validate dates
    if (startDate.value == null || endDate.value == null) {
      Utils.errorSnackBar("Error", "Please select both start and end dates");
      return;
    }

    // Parse discount
    final discount = int.tryParse(discountController.text.trim());
    if (discount == null) {
      Utils.errorSnackBar("Error", "Please enter a valid discount percentage");
      return;
    }

    // Convert dates to ISO 8601 format
    final startDateISO = startDate.value!.toUtc().toIso8601String();
    final endDateISO =
        DateTime(
          endDate.value!.year,
          endDate.value!.month,
          endDate.value!.day,
          23,
          59,
          59,
        ).toUtc().toIso8601String();

    // Call API
    final success = await createPromo(
      title: promoTitleController.text.trim(),
      discount: discount,
      description: descriptionController.text.trim(),
      startDate: startDateISO,
      endDate: endDateISO,
      generatePromocode: generatePromoCode.value,
      generateQrCode: generateQRCode.value,
    );

    if (success) {
      // Navigate back on success
      Get.back();
    }
  }

  /// Create Promo
  Future<bool> createPromo({
    required String title,
    required int discount,
    required String description,
    required String startDate,
    required String endDate,
    required bool generatePromocode,
    required bool generateQrCode,
  }) async {
    try {
      isLoading.value = true;

      // Create request model
      PromoRequestModel requestModel = PromoRequestModel(
        title: title,
        discount: discount,
        description: description,
        startDate: startDate,
        endDate: endDate,
        generatePromocode: generatePromocode,
        generateQrCode: generateQrCode,
      );

      // Make API call
      var response = await ApiService.post(
        ApiEndPoint.promo,
        body: requestModel.toJson(),
      );

      if (response.isSuccess) {
        promoResponseModel = PromoResponseModel.fromJson(response.data);
        Get.snackbar('Success', response.message);
        return true;
      } else {
        Get.snackbar('Error', response.message);
        return false;
      }
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
