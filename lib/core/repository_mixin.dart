import 'package:flutter/cupertino.dart';
import 'package:uber_mobile/core/error/failure.dart';
import 'package:uber_mobile/core/network/network_error.dart';

typedef Operation<T> = Future<T> Function();
typedef SerializableOperation = Future<Map<String, dynamic>> Function();
typedef Deserializer<T> = T Function(Map<String, dynamic> data);
typedef Serializer<T> = Map<String, dynamic> Function(T data);

mixin RepositoryMixin {
  @protected
  Future<T> runOperation<T>(Operation<T> operation) async {
    try {
      return await operation();
    } on NetworkError catch (e) {
      throw ServerOperationFailure(
        message: e.message,
        // wrapped: e.toJson(),
        // response: e.rawResponse,
      );
    } on OperationFailure catch (_) {
      rethrow;
    } catch (e) {
      throw UnknownOperationFailure(e);
    }
  }

  Future<T> runSerializedQuery<T>(
    String key,
    // bool remoteOnly,
    SerializableOperation operation,
    Deserializer<T> deserializer,
    bool secure,
  ) async {
    try {
      Map<String, dynamic>? data;

      // if (!remoteOnly) {
      //   // attempt to load from cache
      // try {
      //     // final cache = await sharedPref.getString(key, secure: secure);
      //     if (cache != null) {
      //       data = json.decode(cache);
      //       await Future.delayed(Duration(milliseconds: 200)); // add wait time
      //       return deserializer(data!);
      //     }
      //   } catch (e) {
      //     // Something went wrong loading from the cache.
      //     // Expected data might have changed.
      //     // Just log a warning and proceed.
      //     AchieveCore.instance.logger.warning("e: $e");
      //   }
      // }

      data = await runOperation(operation);
      // await sharedPref.putString(
      //   key,
      //   json.encode(data),
      //   secure: secure,
      // );
      return deserializer(data!);
    } on OperationFailure catch (_) {
      rethrow;
    } catch (e) {
      throw UnknownOperationFailure(e);
    }
  }
}
