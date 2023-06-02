import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService {
  static final HttpLink httpLink = HttpLink("https://optimum-ostrich-33.hasura.app/v1/graphql",
  defaultHeaders: {
    'content-type': 'application/json',
    'x-hasura-admin-secret': '2GIo9SZqYwku38MPsO6MZxLMceFnj4tCy4U24t4Lk2uEE2vWaxctDsubMJUmAiGx'
  });
  final GraphQLClient client = GraphQLClient(link: httpLink, cache: GraphQLCache());

  // Signing Up a New User
  Future<bool> signUp(String name, String email, String password) async {

    //creating mutation object
    //mutation MyMutation(\$name: String!, \$email: String!, \$password: String!) {
    const String signupMutation = r'''
        mutation MyMutation($name: String!, $email: String!, $password: String!) {
          insert_user(objects: {name: $name, password: $password, username: $email, isActive: true}) {
            returning {
              isActive
              name
              password
              username
            }
          }
        }''';

    // mutation options
    final MutationOptions options = MutationOptions(
        document: gql(signupMutation),
        variables: <String, dynamic>{
          'name': name,
          'email': email,
          'password': password
        }
    );

    // query hasura server
    final QueryResult result =  await client.mutate(options);

    if(result.hasException){
      throw Exception('Signup Failed: ${result.exception.toString()}');
    } else {
      //TODO: show a popup message
      print("SignUp  Success !!! ");
      return true;
    }
  }

  Future<int?> login(String email, String password) async {

    // creating mutation object
    const String loginQuery = r'''
        query login($email: String!, $password: String!) {
          user(where: {password: {_eq: $password}, username: {_eq: $email}}) {
            id
            isActive
            name
            username
          }
        }''';


    // mutation options
    final MutationOptions options = MutationOptions(
        document: gql(loginQuery),
        variables: <String, dynamic>{
          'email': email,
          'password': password
        }
    );

    // query hasura server
    final QueryResult result =  await client.mutate(options);

    if(result.hasException){
      throw Exception('Signup Failed: ${result.exception.toString()}');
    } else {

      // getting response
      Map<String, dynamic>? data = (result.data?['user'] as List<dynamic>).first;


      if (data != null && data.containsKey('id') && data.containsKey('username')) {
        // Email and ID exist in the response
        String userEmail = data['username'] as String;
        int userId = data['id'] as int;
        print('User Email: $userEmail');
        print('User ID: $userId');
        return userId;
      } else {
        return null;
      }


    }

  }

  Future<Map<String, dynamic>> fetchUserData(int? userId) async {

    // creating mutation object
    const String query = r'''
         query getUserbyId($userId: Int!) {
              user_by_pk(id: $userId) {
                  id
                  name
                  username
                  isActive
              }
            }''';

    // mutation options
    final QueryOptions options = QueryOptions(
        document: gql(query),
        variables: <String, dynamic>{
          'userId': userId,
        }
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw Exception('Failed to fetch user data: ${result.exception}');
    }

    return result.data?['user_by_pk'] as Map<String, dynamic>? ?? {};
  }


}