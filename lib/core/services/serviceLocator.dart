import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_mobile/core/config/apiConstants.dart';
import 'package:uber_mobile/core/network/graphql/graphql_client.dart';
import 'package:uber_mobile/core/network/http_client.dart';
import 'package:uber_mobile/core/network/network_event_listner.dart';
import 'package:uber_mobile/utils/appSharedPref.dart';

final sl = GetIt.instance;

Future<void> setupServices() async {
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => AppSharedPref(preferences: sharedPref));

  sl.registerSingleton(HttpClient());

  // final _apiRestHandler = ApiRestHandler(httpClient: sl<HttpClient>());
  // sl.registerFactory(() => _apiRestHandler);

  final netEventListner = NetworkEventListener();

  sl.registerLazySingleton(() => netEventListner);

  sl.registerSingleton<GraphQLClient>(
    GraphQLClientImpl(
      () {
        return sl.get<AppSharedPref>().accessToken;
      },
      apiEndpoint: ApiEndPoint.apiHost,
      // onGraphQLError: netEventListner.onGraphQLError,
      // onNetworkError: netEventListner.onNetworkError,
    ),
  );
}
