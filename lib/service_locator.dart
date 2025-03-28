
import 'package:ctntelematics/modules/eshop/presentation/bloc/eshop_bloc.dart';
import 'package:ctntelematics/modules/map/data/datasources/remote/map_api_client.dart';
import 'package:ctntelematics/modules/map/data/repositories/map_repo_impl.dart';
import 'package:ctntelematics/modules/map/domain/repositories/map_repository.dart';
import 'package:ctntelematics/modules/map/domain/usecases/map_usecase.dart';
import 'package:ctntelematics/modules/websocket/data/datasources/pusher_service.dart';
import 'package:ctntelematics/modules/websocket/presentation/bloc/vehicle_location_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'core/bloc_manager.dart';
import 'modules/authentication/data/datasources/remote/auth_api_client.dart';
import 'modules/authentication/data/repositories/auth_reposiory_impl.dart';
import 'modules/authentication/domain/repositories/auth_repository.dart';
import 'modules/authentication/domain/usecases/auth_usecase.dart';
import 'modules/authentication/presentation/bloc/auth_bloc.dart';
import 'modules/dashboard/data/datasources/remote/dashboard_api_client.dart';
import 'modules/dashboard/data/repositories/dashboard_repo_impl.dart';
import 'modules/dashboard/domain/repositories/dash_vehicle_repo.dart';
import 'modules/dashboard/domain/usecases/dashboard_usecase.dart';
import 'modules/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'modules/eshop/data/datasources/remote/eshop_api_client.dart';
import 'modules/eshop/data/repositories/eshop_repo_impl.dart';
import 'modules/eshop/domain/repositories/eshop_repository.dart';
import 'modules/eshop/domain/usecases/eshop_usecase.dart';
import 'modules/map/presentation/bloc/map_bloc.dart';
import 'modules/profile/data/datasources/remote/profile_api_client.dart';
import 'modules/profile/data/repositories/profile_repo_impl.dart';
import 'modules/profile/domain/repositories/profile_repository.dart';
import 'modules/profile/domain/usecases/profile_usecase.dart';
import 'modules/profile/presentation/bloc/profile_bloc.dart';
import 'modules/service/data/datasources/remote/service_api_client.dart';
import 'modules/service/data/repositories/service_repo_impl.dart';
import 'modules/service/domain/repositories/service_repository.dart';
import 'modules/service/domain/usecases/service_usecases.dart';
import 'modules/service/presentation/bloc/service_bloc.dart';
import 'modules/vehincle/data/datasources/remote/vehicle_api_client.dart';
import 'modules/vehincle/data/repositories/vehicle_repo_impl.dart';
import 'modules/vehincle/domain/repositories/vehicle_repo.dart';
import 'modules/vehincle/domain/usecases/vehicle_usecase.dart';
import 'modules/vehincle/presentation/bloc/vehicle_bloc.dart';
import 'modules/websocket/data/repositories/pusher_repo_impl.dart';
import 'modules/websocket/domain/repositories/pusher_repository.dart';
import 'modules/websocket/domain/usecases/get_vehicle_location_update_usecase.dart';

final sl = GetIt.instance;
final blocManager = BlocManager();
Future<void> initializeDependencies() async {
  // Check if Dio is already registered
  if (!sl.isRegistered<Dio>()) {
    sl.registerSingleton(Dio());
  }

  // Register ApiClient
  sl.registerSingleton<AuthApiClient>(AuthApiClient(sl()));
  sl.registerSingleton<DashboardApiClient>(DashboardApiClient(sl()));
  sl.registerSingleton<VehicleApiClient>(VehicleApiClient(sl()));
  sl.registerSingleton<ProfileApiClient>(ProfileApiClient(sl()));
  sl.registerSingleton<MapApiClient>(MapApiClient(sl()));
  sl.registerSingleton<EshopApiClient>(EshopApiClient(sl()));
  sl.registerSingleton<ServiceApiClient>(ServiceApiClient(sl()));
  // sl.registerSingleton<PusherService>(PusherService(token, userId));

  // Register Repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<DashboardRepository>(DashboardRepositoryImpl(sl()));
  sl.registerSingleton<VehicleRepository>(VehicleRepositoryImpl(sl()));
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(sl()));
  sl.registerSingleton<MapRepository>(MapRepositoryImpl(sl()));
  sl.registerFactory<PusherRepository>(() => PusherRepositoryImpl(sl<PusherService>()));
  sl.registerSingleton<EshopRepository>(EshopRepositoryImpl(sl()));
  sl.registerSingleton<ServiceRepository>(ServiceRepositoryImpl(sl()));
  // sl.registerSingleton<PusherRepository>(PusherRepositoryImpl(sl<PusherService>()));

  // Register UseCase
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<GenerateOtpUseCase>(GenerateOtpUseCase(sl()));
  sl.registerSingleton<ChangePasswordUseCase>(ChangePasswordUseCase(sl()));
  // sl.registerSingleton<VerifyEmailUseCase>(VerifyEmailUseCase(sl()));
  sl.registerSingleton<DashboardUseCase>(DashboardUseCase(sl()));
  sl.registerSingleton<VehicleUseCase>(VehicleUseCase(sl()));
  sl.registerSingleton<ProfileGenerateOtpUseCase>(ProfileGenerateOtpUseCase(sl()));
  sl.registerSingleton<ProfileChangePasswordUseCase>(ProfileChangePasswordUseCase(sl()));
  sl.registerSingleton<ProfileVerifyEmailUseCase>(ProfileVerifyEmailUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl()));
  sl.registerSingleton<GetLastLocationUseCase>(GetLastLocationUseCase(sl()));
  sl.registerSingleton<GetRouteHistoryUseCase>(GetRouteHistoryUseCase(sl()));
  sl.registerSingleton<GetVehicleRouteHistoryUseCase>(GetVehicleRouteHistoryUseCase(sl()));
  // sl.registerSingleton<GetVehicleLocationUpdateUseCase>(GetVehicleLocationUpdateUseCase(sl<PusherRepository>()));
  sl.registerFactory<GetVehicleLocationUpdateUseCase>(() => GetVehicleLocationUpdateUseCase(sl<PusherRepository>()));
  sl.registerFactory<GetScheduleUseCase>(() => GetScheduleUseCase(sl()));
  sl.registerFactory<CreateScheduleUseCase>(() => CreateScheduleUseCase(sl()));
  sl.registerFactory<ProfileVehicleUseCase>(() => ProfileVehicleUseCase(sl()));
  sl.registerFactory<SendLocationUseCase>(() => SendLocationUseCase(sl()));
  sl.registerFactory<GetProductsUseCase>(() => GetProductsUseCase(sl()));
  sl.registerFactory<GetCategoryUseCase>(() => GetCategoryUseCase(sl()));
  sl.registerFactory<GetProductUseCase>(() => GetProductUseCase(sl()));
  sl.registerFactory<TripsUseCase>(() => TripsUseCase(sl()));
  sl.registerFactory<InitiatePaymentUseCase>(() => InitiatePaymentUseCase(sl()));
  sl.registerFactory<ConfirmPaymentUseCase>(() => ConfirmPaymentUseCase(sl()));
  sl.registerFactory<DeliveryLocationUseCase>(() => DeliveryLocationUseCase(sl()));
  sl.registerFactory<ScheduleNoticeUseCase>(() => ScheduleNoticeUseCase(sl()));
  sl.registerFactory<CompleteScheduleUseCase>(() => CompleteScheduleUseCase(sl()));
  sl.registerFactory<SingleScheduleNoticeUseCase>(() => SingleScheduleNoticeUseCase(sl()));
  sl.registerFactory<ExpensesUseCase>(() => ExpensesUseCase(sl()));
  sl.registerFactory<GetServicesUseCase>(() => GetServicesUseCase(sl()));
  sl.registerFactory<GetCountryStatesUseCase>(() => GetCountryStatesUseCase(sl()));
  sl.registerFactory<InitializeServicePaymentUseCase>(() => InitializeServicePaymentUseCase(sl()));
  sl.registerFactory<RequestServiceUseCase>(() => RequestServiceUseCase(sl()));


  // Register Bloc
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => GenerateOtpBloc(sl()));
  sl.registerFactory(() => ChangePwdBloc(sl()));
  // sl.registerFactory(() => EmailVerifyBloc(sl()));
  sl.registerFactory(() => DashVehiclesBloc(sl()));
  // sl.registerFactory(() => VehiclesBloc(sl()));
  sl.registerFactory(() => ProfileGenerateOtpBloc(sl()));
  sl.registerFactory(() => ProfileChangePwdBloc(sl()));
  sl.registerFactory(() => ProfileEmailVerifyBloc(sl()));
  sl.registerFactory(() => LogoutBloc(sl()));
  sl.registerFactory(() => LastLocationBloc(sl()));
  // sl.registerFactory(() => RouteHistoryBloc(sl()));
  sl.registerFactory(() => VehicleRouteHistoryBloc(sl()));
  sl.registerFactory(() => VehicleLocationBloc(sl()));
  sl.registerFactory(() => GetScheduleBloc(sl()));
  sl.registerFactory(() => CreateScheduleBloc(sl()));
  sl.registerFactory(() => ProfileVehiclesBloc(sl()));
  sl.registerFactory(() => SendLocationBloc(sl()));
  sl.registerFactory(() => EshopGetAllProductBloc(sl()));
  sl.registerFactory(() => EshopGetCategoryBloc(sl()));
  sl.registerFactory(() => EshopGetProductBloc(sl()));
  sl.registerFactory(() => VehicleTripBloc(sl()));
  sl.registerFactory(() => InitiatePaymentBloc(sl()));
  sl.registerFactory(() => ConfirmPaymentBloc(sl()));
  sl.registerFactory(() => DeliveryLocationBloc(sl()));
  sl.registerFactory(() => GetScheduleNoticeBloc(sl()));
  sl.registerFactory(() => CompleteScheduleBloc(sl()));
  sl.registerFactory(() => GetSingleScheduleNoticeBloc(sl()));
  sl.registerFactory(() => GetExpensesBloc(sl()));
  sl.registerFactory(() => GetServicesBloc(sl()));
  sl.registerFactory(() => GetCountryStateBloc(sl()));
  sl.registerFactory(() => InitiateServicePaymentBloc(sl()));
  sl.registerFactory(() => RequestServiceBloc(sl()));

}

void resetApp() async {
  // Clear all Blocs
  blocManager.clearAllBlocs();

  // Reset dependency injection
  await sl.reset(dispose: true); // Disposes all instances

  // Reinitialize dependencies
  initializeDependencies();

  print(">>>>>> Dependencies reinitialized <<<<<<");
}

// void resetApp() {
//
//   // Clear all Blocs
//   blocManager.clearAllBlocs();
//
//   // Reset dependency injection
//   sl.reset();
//
//   // Reinitialize dependencies
//   WidgetsFlutterBinding.ensureInitialized();
//   initializeDependencies();
//
//   print(">>>>>> initializeDependencies <<<<<<");
//
// }


///
//
// void resetAllBlocs() {
//   sl<UserBloc>().add(ClearAllDataEvent());
//   sl<SettingsBloc>().add(ClearAllDataEvent());
//   sl<ProfileBloc>().add(ClearAllDataEvent());
//   // Add other Blocs as needed
// }
//
// void resetServices() {
//   sl.resetLazySingleton<UserRepository>();
//   sl.resetLazySingleton<SettingsRepository>();
// }
