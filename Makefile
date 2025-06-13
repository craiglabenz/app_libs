test_client_auth:
	cd packages/client_auth && flutter test

test_client_data:
	cd packages/client_data && flutter test

test_shared_data:
	cd packages/shared_data && dart test

test_shared_data_firebase:
	cd packages/shared_data_firebase && flutter test

test_pkgs: test_client_auth test_client_data test_shared_data test_shared_data_firebase

test: test_pkgs
