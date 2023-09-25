import 'package:get_it/get_it.dart';
import 'package:onyxswap/views/kyc/viewmodel/nin_viewmodel.dart';
import 'package:onyxswap/views/wallet/viewmodel/wallet_viewmodel.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/local_cache/local_cache.dart';
import '../data/local/local_cache/local_cache_impl.dart';
import '../data/remote/auth/auth_interface.dart';
import '../data/remote/auth/auth_repository.dart';
import '../data/remote/auth/auth_service.dart';

GetIt locator = GetIt.instance;
Future<void> setupLocator() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);
  locator.registerLazySingleton<LocalCache>(
      () => LocalCacheImpl(sharedPreferences));
   locator.registerLazySingleton<AuthRepositiory>(
    () => AuthRepositoryImpl(),
  );
  locator.registerLazySingleton<AuthService>(
    () => AuthServiceimpl(),
  );
  locator.registerLazySingleton<NinViewModel>(() => NinViewModel());
  locator.registerLazySingleton<WalletViewModel>(() => WalletViewModel());
}
