/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/auth_user_endpoint.dart' as _i2;
import 'package:shared_data/src/models/user.dart' as _i3;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'authUser': _i2.AuthUserEndpoint()
        ..initialize(
          server,
          'authUser',
          'auth',
        )
    };
    connectors['authUser'] = _i1.EndpointConnector(
      name: 'authUser',
      endpoint: endpoints['authUser']!,
      methodConnectors: {
        'validateKey': _i1.MethodConnector(
          name: 'validateKey',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authUser'] as _i2.AuthUserEndpoint)
                  .validateKey(session),
        ),
        'createAnonymousUser': _i1.MethodConnector(
          name: 'createAnonymousUser',
          params: {
            'socialId': _i1.ParameterDescription(
              name: 'socialId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authUser'] as _i2.AuthUserEndpoint)
                  .createAnonymousUser(
            session,
            socialId: params['socialId'],
          ),
        ),
        'logInEmailUser': _i1.MethodConnector(
          name: 'logInEmailUser',
          params: {
            'socialId': _i1.ParameterDescription(
              name: 'socialId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'credential': _i1.ParameterDescription(
              name: 'credential',
              type: _i1.getType<_i3.EmailCredential>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authUser'] as _i2.AuthUserEndpoint).logInEmailUser(
            session,
            socialId: params['socialId'],
            credential: params['credential'],
          ),
        ),
        'addEmailToUser': _i1.MethodConnector(
          name: 'addEmailToUser',
          params: {
            'socialId': _i1.ParameterDescription(
              name: 'socialId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'credential': _i1.ParameterDescription(
              name: 'credential',
              type: _i1.getType<_i3.EmailCredential>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authUser'] as _i2.AuthUserEndpoint).addEmailToUser(
            session,
            socialId: params['socialId'],
            credential: params['credential'],
          ),
        ),
        'createUserWithEmailAndPassword': _i1.MethodConnector(
          name: 'createUserWithEmailAndPassword',
          params: {
            'socialId': _i1.ParameterDescription(
              name: 'socialId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'credential': _i1.ParameterDescription(
              name: 'credential',
              type: _i1.getType<_i3.EmailCredential>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authUser'] as _i2.AuthUserEndpoint)
                  .createUserWithEmailAndPassword(
            session,
            socialId: params['socialId'],
            credential: params['credential'],
          ),
        ),
        'addAppleToUser': _i1.MethodConnector(
          name: 'addAppleToUser',
          params: {
            'socialId': _i1.ParameterDescription(
              name: 'socialId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'credential': _i1.ParameterDescription(
              name: 'credential',
              type: _i1.getType<_i3.AppleCredential>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authUser'] as _i2.AuthUserEndpoint).addAppleToUser(
            session,
            socialId: params['socialId'],
            credential: params['credential'],
          ),
        ),
        'addGoogleToUser': _i1.MethodConnector(
          name: 'addGoogleToUser',
          params: {
            'socialId': _i1.ParameterDescription(
              name: 'socialId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'credential': _i1.ParameterDescription(
              name: 'credential',
              type: _i1.getType<_i3.GoogleCredential>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authUser'] as _i2.AuthUserEndpoint).addGoogleToUser(
            session,
            socialId: params['socialId'],
            credential: params['credential'],
          ),
        ),
      },
    );
  }
}
