import 'package:get/get.dart';
import '../../../core/models/customer_model.dart';
import '../../../core/services/database_service.dart';

class CustomerController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();

  final RxList<CustomerModel> customers = <CustomerModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      isLoading.value = true;
      List<Map<String, dynamic>> customerMaps = await _db.database.query(
        'customers',
        orderBy: 'first_name ASC',
      );

      customers.value =
          customerMaps.map((map) => CustomerModel.fromMap(map)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load customers: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
