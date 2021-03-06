require "spec_helper"

describe MiqServer do
  context "LogManagement" do
    let(:depot)          { FactoryGirl.build(:file_depot, :uri => uri) { |d| d.save(:validate => false) } }
    let(:new_depot_hash) { {:uri => "nfs://server.example.com", :username => "new_user", :password => "new_pass"} }
    let(:uri)            { "smb://server/share" }

    before do
      _, @miq_server, @zone = EvmSpecHelper.create_guid_miq_server_zone
      depot.update_authentication(:default => {:userid => "user", :password => "pass"})
    end

    context "#set_log_depot_settings" do
      it "creates a new log depot" do
        @miq_server.set_log_depot_settings(new_depot_hash)

        expect(@miq_server.log_file_depot.depot_hash).to eq(new_depot_hash)
      end

      it "updates an existing log depot" do
        @miq_server.update_attributes(:log_file_depot_id => depot.id)

        @miq_server.set_log_depot_settings(new_depot_hash)

        expect(@miq_server.log_file_depot.depot_hash).to eq(new_depot_hash)
      end
    end

    context "#get_log_depot_settings" do
      let(:depot_hash) { {:uri => uri, :username => "user", :password => "pass"} }

      it "set on miq_server" do
        @miq_server.update_attributes(:log_file_depot_id => depot.id)

        expect(@miq_server.get_log_depot_settings).to eq(depot_hash)
      end

      it "set on zone" do
        @zone.update_attributes(:log_file_depot_id => depot.id)

        expect(@miq_server.get_log_depot_settings).to eq({:from_zone => true}.merge(depot_hash))
      end
    end
  end
end
