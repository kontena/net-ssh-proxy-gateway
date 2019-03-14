RSpec.describe Net::SSH::Proxy::Gateway do
  it "has a version number" do
    expect(Net::SSH::Proxy::Gateway::VERSION).not_to be nil
  end

  let(:socket) { instance_double(Socket, flush: true, readpartial: nil) }
  let(:gateway) { instance_double(Net::SSH::Gateway, active?: true) }

  before do
    allow(socket).to receive(:closed?).and_return(true)
    allow(gateway).to receive(:close)
  end

  after do
    allow(socket).to receive(:closed?).and_return(false)
  end

  subject { described_class.new(nil, nil, gateway) }

  it "is accepted by Net::SSH.start" do
    expect(gateway).to receive(:open).with('10.0.0.1', 22).and_return(12345)
    expect(Socket).to receive(:tcp).with('localhost', 12345, nil, nil, connect_timeout: nil).and_return(socket)
    expect(socket).to receive(:write).with("SSH-2.0-Ruby/Net::SSH_#{Net::SSH::Version::STRING} #{RUBY_PLATFORM}\r\n")
    expect{Net::SSH.start('10.0.0.1', 'user', proxy: subject)}.to raise_error(Net::SSH::Disconnect)
  end
end
