import '../GraphqlRequest.dart';

class CreateSessionRequest extends GraphqlRequest {
  CreateSessionRequest(dynamic tokenId)
      : super(_query, variables: {"tokenId": tokenId});

  static final String _query = r"""
                    mutation($tokenId: String!) {
  createSession(tokenId: $tokenId) {
    user {
      id
      phoneNumber
      dateOfBirth
      createdDate
    }
    isSignupComplete
  }
}
                    """;
}
