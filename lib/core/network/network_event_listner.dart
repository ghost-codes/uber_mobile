/// network event types
enum NetworkEventType { maintenance, authTokenExpiry }

/// Class to Listen for Network Events
///
/// Currently, it listens for [NetworkEventType.maintenance]
/// and [NetworkEventType.authTokenExpiry]
///
/// It exposes a stream which you can listen to
/// for events
class NetworkEventListener
//  extends
//  ChangeNotifier<NetworkEventType>
{
  // /// constructor
  // // NetworkEventListener({
  // //   // required Future<bool> Function() refreshSession,
  // // }) : _refreshSession = refreshSession;

  // static const String name = 'NetworkEventListener';

  // // final Future<bool> Function() _refreshSession;

  // GraphQLClient get _gqlClient => sl.get<GraphQLClient>();

  // /// Fires when a an auth error occurs.
  // Stream<ProviderEvent<NetworkEventType>> get onAuthError {
  //   return stream.where((event) => event == NetworkEventType.authTokenExpiry);
  // }

  // // /// Fires when network gets  is in Maintenance
  // // Stream<NetworkEventType> get onMaintenanceMode {
  // //   return stream.where((event) => event == NetworkEventType.maintenance);
  // // }

  // /// Fires when a new Fetch Error Occurs (currently Auth)
  // void onNetworkError(NetworkError error) {
  //   final _message = error.message;

  //   // if (_message.contains('503')) {
  //   //   addEvent(NetworkEventType.maintenance);
  //   //   return;
  //   // }
  // }

  // /// Fires when a new GraphQL related error occurs
  // ///
  // /// if this returns true, the failed request is retried
  // /// else it continues with the error.
  // Future<bool> onGraphQLError(List<GraphQLError?> errors) async {
  //   final _authError = errors.firstWhereOrNull((e) {
  //     final _ext = e?.extensions ?? {};
  //     return _ext['category'] == 'authentication' && e?.message == 'Unauthenticated.';
  //   });

  //   /// handle auth error
  //   if (_authError != null) {
  //     //   // _gqlClient.pauseRequests();
  //     //   // final _isSuccess = await _refreshSession();
  //     //   // _gqlClient.resumeRequests();

  //     //   /// if [_refreshSession] function returns `True`,
  //     //   /// then we should return true so the request is
  //     //   /// retried
  //     //   // if (_isSuccess) {
  //     //   //   return true;
  //     //   // }
  //     onSuccess(data: NetworkEventType.authTokenExpiry);
  //   }

  //   return false;
  // }
}
