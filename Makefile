test:
	BG_WAIT='Running websocket server' CABLE_URL='ws://0.0.0.0:3334/cable' bundle exec rspec

test-erl:
	PROCFILE='Procfile.spec_erl' BG_WAIT='Booted erlycable' CABLE_URL='ws://0.0.0.0:3335/ws/cable' bundle exec rspec
