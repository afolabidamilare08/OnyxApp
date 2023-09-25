import 'package:dio/dio.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/widgets/base_view_model.dart';

import '../../../models/failure.dart';
import '../../../widgets/flushbar.dart';

class AllTransactions extends BaseViewModel {
  final NetworkClient _networkClient = NetworkClient();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  List transactions = [];
  Future allTransaction() async {
    try {
      isLoading = true;
      String? userid = _localCache.getToken();
      await _networkClient.post(ApiRoutes.alltransaction,
          body: FormData.fromMap({'userId': userid}));
      transactions = _networkClient.data['success'];
      transactions = transactions.reversed.toList();
      notifyListeners();
      isLoading = false;
    } on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
  }

  AllTransactions() {
    allTransaction();
  }
}
