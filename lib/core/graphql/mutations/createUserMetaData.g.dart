import '../GraphqlRequest.dart';

class CreateUserMetaDataRequest extends GraphqlRequest {
  CreateUserMetaDataRequest(
    dynamic phoneNumber,
    dynamic firebaseAuthId,
    dynamic dateOfBirth,
  ) : super(_query, variables: {
          "phoneNumber": phoneNumber,
          "firebaseAuthId": firebaseAuthId,
          "dateOfBirth": dateOfBirth
        });

  static final String _query = r"""
                    mutation($phoneNumber: String!, $firebaseAuthId: String!, $dateOfBirth: Time!) {
  createUser(data: {phoneNumber: $phoneNumber, firebaseAuthId: $firebaseAuthId, dateOfBirth: $dateOfBirth}) {
    id
    phoneNumber
    dateOfBirth
    createdDate
  }
}
                    """;
}
