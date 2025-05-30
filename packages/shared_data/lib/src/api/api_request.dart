import 'dart:io';
import 'package:shared_data/shared_data.dart';

/// {@template ApiRequest}
/// Container for information needed to submit a network request.
/// {@endtemplate}
abstract class ApiRequest {
  /// {@macro ApiRequest}
  const ApiRequest({
    required this.url,
    this.user,
    Headers headers = const {},
  }) : _headers = headers;

  /// Optional authentication token behind this request.
  final AuthUser? user;

  /// Destination of this request.
  final ApiUrl url;

  /// Default content type header.
  String get contentType => 'application/json';

  /// Starter headers for this request. If [user] is not null, its ApiKey will
  /// be added as the authorization header.
  final Headers _headers;

  /// Finalized headers, combining starter headers with the builder method.
  Headers get headers => buildHeaders();

  /// Returns complete map of HTTP headers for this request.
  Headers buildHeaders() {
    final headers = Map<String, String>.from(_headers);
    headers['Content-Type'] = contentType;
    if (user != null) {
      // TODO(craiglabenz): Recreate this
      // headers[HttpHeaders.authorizationHeader] = 'Token ${user!.apiKey}';
    }
    return headers;
  }
}

/// {@template ReadApiRequest}
/// Subtype of [ApiRequest] for read, or GET requests. Along with having that
/// HTTP verb, these requests also have querystrings and not request bodies.
/// {@endtemplate}
class ReadApiRequest extends ApiRequest {
  /// {@macro ReadApiRequest}
  const ReadApiRequest({
    required super.url,
    super.headers,
    super.user,
    this.params,
  });

  /// GET/querystring-style payload of this request.
  final Params? params;
}

/// {@template AuthenticatedReadApiRequest}
/// Read requests that require user authentication to complete successfully.
/// {@endtemplate}
class AuthenticatedReadApiRequest extends ReadApiRequest {
  /// {@macro AuthenticatedReadApiRequest}
  const AuthenticatedReadApiRequest({
    required AuthUser user,
    required super.url,
    super.headers,
    super.params,
  }) : super(user: user);
}

/// {@template WriteApiRequest}
/// Subtype of [ApiRequest] for write, or POST/PATCH/PUT requests. Along with
/// having one of those HTTP verbs, these requests also have request bodies and
/// not querystrings.
/// {@endtemplate}
class WriteApiRequest extends ApiRequest {
  /// {@macro WriteApiRequest}
  const WriteApiRequest({
    required super.url,
    required this.body,
    super.user,
    super.headers,
  });

  /// Request payload in serialized JSON format.
  final Json? body;
}

/// {@template AuthenticatedReadApiRequest}
/// Read requests that require user authentication to complete successfully.
/// {@endtemplate}
class AuthenticatedWriteApiRequest extends WriteApiRequest {
  /// {@macro AuthenticatedWriteApiRequest}
  const AuthenticatedWriteApiRequest({
    required AuthUser user,
    required super.url,
    super.headers,
    super.body,
  }) : super(user: user);
}

// /// {@template RequestBody}
// /// Payload for an [ApiRequest]. Extended with Freezed by app libraries.
// /// {@endtemplate}
// abstract class RequestBody {
//   /// {@macro RequestBody}
//   const RequestBody();
// }

// /// {@template EmptyRequestBody}
// /// Empty payload for an [ApiRequest] with no data.
// /// {@endtemplate}
// class EmptyRequestBody extends RequestBody {
//   /// {@macro EmptyBody}
//   const EmptyRequestBody();
// }

// /// {@template FlexibleRequestBody}
// /// Request payload that accepts arbitrary Json. Prefer typed [RequestBody]
// /// subclasses instead of this.
// /// {@endtemplate}
// class FlexibleRequestBody extends RequestBody {
//   /// {@macro FlexibleBody}
//   const FlexibleRequestBody(this.json);

//   /// Request payload.
//   Json json;

//   Json toJson() => json;
// }
