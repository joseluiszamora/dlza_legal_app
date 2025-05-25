import 'package:get_it/get_it.dart';
import 'blocs.dart';

GetIt getIt = GetIt.instance;

void serviceLocatorInit() {
  getIt.registerLazySingleton<AgencyBloc>(() => AgencyBloc());
  getIt.registerLazySingleton<MarcaBloc>(() => MarcaBloc());
  getIt.registerLazySingleton<EmployeeBloc>(() => EmployeeBloc());
}
