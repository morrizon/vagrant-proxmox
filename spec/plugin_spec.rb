require 'spec_helper'

describe 'Vagrant Proxmox plugin' do

	specify { Vagrant.should have_plugin 'Proxmox' }

	describe 'contains a fix for RestClient header unescaping bug' do
		let(:request) { RestClient::Request.new method: :get, url: 'url', cookies: { key: '+%20%21' }}
		it 'should not unescape the cookies' do
			request.make_headers({})['Cookie'].should == 'key=+%20%21'
		end
	end

	describe 'when vagrant log level is set in ENV[VAGRANT_LOG]' do
		before { ENV['VAGRANT_LOG'] = 'DEBUG' }
		it 'should create a new vagrant proxmox logger ' do
			expect(Log4r::Logger).to receive(:new).with('vagrant_proxmox').and_call_original
			VagrantPlugins::Proxmox::Plugin.setup_logging
		end
	end

end
