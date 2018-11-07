test:
	ADAPTER=any_cable BG_WAIT='Handle WebSocket connections at /cable' CABLE_URL='ws://localhost:3334/cable' bundle exec rspec

test-erl:
	ADAPTER=any_cable PROCFILE='Procfile.spec_erl' BG_WAIT='Booted erlycable' CABLE_URL='ws://localhost:3335/ws/cable' bundle exec rspec
