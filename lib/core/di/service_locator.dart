import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../navigator/app_navigator.dart';
import '../navigator/core_navigator.dart';
import '../router.dart';

import 'iod.dart';

import '../../modules/companies/infra/repositories/activities_repository_impl.dart';
import '../../modules/companies/domain/repositories/activities_repository.dart';
import '../../modules/companies/domain/usecases/delete_activity.dart';
import '../../modules/companies/domain/usecases/get_activities.dart';
import '../../modules/companies/domain/usecases/register_activity.dart';
import '../../modules/companies/domain/usecases/update_activity.dart';
import '../../modules/companies/ui/activities_list_view_model.dart';
import '../../modules/companies/ui/activity_registration_view_model.dart';
import '../../modules/inspections/domain/repositories/inspections_repository.dart';
import '../../modules/inspections/domain/usecases/get_inspections_usecase.dart';
import '../../modules/inspections/infra/data_sources/inspections_local_data_source.dart';
import '../../modules/inspections/infra/data_sources/inspections_remote_data_source.dart';
import '../../modules/inspections/infra/repositories/inspections_repository_impl.dart';
import '../../modules/inspections/ui/inspections_viewmodel.dart';
import '../database/app_database.dart';
import '../network/mock_interceptor.dart';

final IoD ioD = IoD.instance;

void configureDependencies() {
  if (ioD.isRegistered<AppDatabase>()) return;

  ioD
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<AssetBundle>(() => rootBundle)
    ..registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.mock.com'));
      dio.interceptors.add(MockInterceptor(ioD.get<AssetBundle>()));
      return dio;
    })
    ..registerLazySingleton<InspectionsRemoteDataSource>(() => DioInspectionsRemoteDataSource(ioD.get<Dio>()))
    ..registerLazySingleton<InspectionsLocalDataSource>(() => SqliteInspectionsLocalDataSource(ioD.get<AppDatabase>()))
    ..registerLazySingleton<InspectionsRepository>(
      () => InspectionsRepositoryImpl(
        remoteDataSource: ioD.get<InspectionsRemoteDataSource>(),
        localDataSource: ioD.get<InspectionsLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<GetInspectionsUseCase>(() => GetInspectionsUseCase(ioD.get<InspectionsRepository>()))
    ..registerLazySingleton<InspectionsViewModel>(
      () => InspectionsViewModel(getInspectionsUseCase: ioD.get<GetInspectionsUseCase>()),
    )
    ..registerLazySingleton<AppNavigator>(() => CoreNavigator(appRouter))
    ..registerLazySingleton<ActivitiesRepository>(() => ActivitiesRepositoryImpl(ioD.get<AppDatabase>()))
    ..registerLazySingleton<GetActivities>(() => GetActivities(ioD.get<ActivitiesRepository>()))
    ..registerLazySingleton<RegisterActivity>(() => RegisterActivity(ioD.get<ActivitiesRepository>()))
    ..registerLazySingleton<UpdateActivity>(() => UpdateActivity(ioD.get<ActivitiesRepository>()))
    ..registerLazySingleton<DeleteActivity>(() => DeleteActivity(ioD.get<ActivitiesRepository>()))
    ..registerLazySingleton<ActivitiesListViewModel>(
      () => ActivitiesListViewModel(ioD.get<GetActivities>(), ioD.get<DeleteActivity>()),
    )
    ..registerFactory<ActivityRegistrationViewModel>(
      () => ActivityRegistrationViewModel(ioD.get<RegisterActivity>(), ioD.get<UpdateActivity>()),
    );
}
