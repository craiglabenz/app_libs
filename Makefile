test_client_auth:
	cd packages/client_auth && flutter test

test_client_data:
	cd packages/client_data && flutter test

test_shared_data:
	cd packages/shared_data && dart test

test_server_data:
	cd packages/server_data && dart test

test_pkgs: test_client_auth test_client_data test_shared_data test_server_data

test: test_pkgs
