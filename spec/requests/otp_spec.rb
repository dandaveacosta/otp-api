require 'rails_helper'

RSpec.describe "OTP API", type: :request do
  describe "POST /otp/generate" do
    it "generates an OTP" do
      post '/otp/generate', params: { user_number: 123 }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /otp/verify" do
    it "verifies an OTP" do
      post '/otp/generate', params: { user_number: 123 }
      otp = JSON.parse(response.body)['otp']

      post '/otp/verify', params: { user_number: 123, otp: otp }

      expect(response).to have_http_status(:ok)
    end
  end
end
