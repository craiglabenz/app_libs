import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_data/shared_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase_auth.User {
  bool get isNew;
}

class MockAuthUser extends Mock implements AuthUser {}

class MockUserMetadata extends Mock implements firebase_auth.UserMetadata {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => 0;
}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockAuthorizationCredentialAppleID extends Mock
    implements AuthorizationCredentialAppleID {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}
