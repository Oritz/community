require 'spec_helper'
require 'webmock/rspec'
require 'platforms/platform'

module Platform
  describe Network do
    class TestPlatform
      extend Network
    end

    describe "get" do
      it "should return nil if url is nil" do
        expect(TestPlatform.get(nil)).to eq nil
      end

      it "should return nil if url doesn't start with 'http://'" do
        expect(TestPlatform.get("test_url")).to eq nil
      end

      it "should return nil if a request returns invalid json data" do
        stub_request(:any, "www.example.com").to_return(
                                                        status: 200,
                                                        body: "invalid:json",
                                                        header: {
                                                          'Content-Type'=> "application/json",
                                                          'Content-Length'=> 12
                                                        })
        expect(TestPlatform.get("http://www.example.com")).to eq nil
      end

      it "should return nil if a response is not 200" do
        stub_request(:any, "www.example.com").to_return(status: [401, "Unauthorized"])
        expect(TestPlatform.get("http://www.example.com")).to eq nil
      end

      it "should return data if a request is ok" do
        data = { "a" => 1, "b" => "ok" }
        stub_request(:any, "www.example.com").to_return(
                                                        status: 200,
                                                        body: data.to_json,
                                                        header: {
                                                          'Content-Type'=> "application/json",
                                                          'Content-Length'=> data.to_json.length
                                                        })
        expect(TestPlatform.get("http://www.example.com")).to eq data
      end
    end
  end
end
