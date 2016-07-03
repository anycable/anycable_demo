shared_context "background_processes" do
  before(:all) do
    rout, wout = IO.pipe
    @hive_pid = Process.spawn('hivemind Procfile.spec', out: wout)

    Timeout.timeout(10) do
      loop do
        output = rout.readline
        break if output =~ /RPC server is listening on/
      end
    end
  end

  after(:all) do
    Process.kill 'SIGKILL', @hive_pid
    Process.wait @hive_pid
  end
end
