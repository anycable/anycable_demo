test:
	CABLE_URL='ws://0.0.0.0:8080/cable' bundle exec rspec

test-erl:
	PROCFILE='Procfile.rpc' CABLE_URL='ws://0.0.0.0:8081/ws/cable' bundle exec rspec
