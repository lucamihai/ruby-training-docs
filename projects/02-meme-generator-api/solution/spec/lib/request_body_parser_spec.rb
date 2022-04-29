require "rspec"
require 'spec_helper'

require "./lib/request_body_parser.rb"

RSpec.describe RequestBodyParser do
  describe ".extract_meme_arguments" do
    context "Given request with all arguments" do
      subject {
        request_body_contents = '
        {
          "original_image_path": "original.jpg",
          "final_image_path": "final.jpg",
          "captions": [
            {
              "text": "some funny text hahaha",
              "font": "Times New Roman",
              "fill_color": "Green",
              "under_color": "Blue",
              "point_size": "13"
            },
            {
              "text": "yet another funny text lmao",
              "font": "Times New Roman",
              "fill_color": "Green",
              "under_color": "Blue",
              "point_size": "13"
            }
          ]
        }'
       
        RequestBodyParser.extract_meme_arguments(request_body_contents) 
      }
      it "returns expected entity" do
        expect(subject.original_image_path).to eq "original.jpg"
        expect(subject.final_image_path).to eq "final.jpg"
        expect(subject.captions.count).to eq 2
        expect(subject.captions[0].text).to eq "some funny text hahaha"
        expect(subject.captions[0].font).to eq "Times New Roman"
        expect(subject.captions[0].fill_color).to eq "Green"
        expect(subject.captions[0].under_color).to eq "Blue"
        expect(subject.captions[0].point_size).to eq 13
        expect(subject.captions[1].text).to eq "yet another funny text lmao"
        expect(subject.captions[1].font).to eq "Times New Roman"
        expect(subject.captions[1].fill_color).to eq "Green"
        expect(subject.captions[1].under_color).to eq "Blue"
        expect(subject.captions[1].point_size).to eq 13
      end
    end

    context "Given request with no captions" do
      subject {
        request_body_contents = '
        {
          "original_image_path": "original.jpg",
          "final_image_path": "final.jpg"
        }'
        RequestBodyParser.extract_meme_arguments(request_body_contents) 
      }
      it "returns expected entity" do
        expect(subject.original_image_path).to eq "original.jpg"
        expect(subject.final_image_path).to eq "final.jpg"
        expect(subject.captions).to eq []
      end
    end

    context "Given request with no arguments" do
      subject {
        request_body_contents = '{}'
        RequestBodyParser.extract_meme_arguments(request_body_contents) 
      }
      it "returns expected entity" do
        expect(subject.original_image_path).to eq nil
        expect(subject.final_image_path).to eq nil
        expect(subject.captions).to eq []
      end
    end
  end

  describe ".extract_signup_arguments" do
    context "Given request with no captions" do
      it "returns expected entity" do
        request_body_contents = '
        {
          "username": "admin",
          "password": "1234"
        }'

        signup_arguments = RequestBodyParser.extract_signup_arguments(request_body_contents)

        expect(signup_arguments.username).to eq "admin"
        expect(signup_arguments.password).to eq "1234"
      end
    end
  end

  describe ".extract_login_arguments" do
    context "Given request with no captions" do
      it "returns expected entity" do
        request_body_contents = '
        {
          "username": "admin",
          "password": "1234"
        }'

        signup_arguments = RequestBodyParser.extract_login_arguments(request_body_contents)

        expect(signup_arguments.username).to eq "admin"
        expect(signup_arguments.password).to eq "1234"
      end
    end
  end
end
