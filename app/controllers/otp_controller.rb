class OtpController < ApplicationController
  skip_before_action :verify_authenticity_token

  def generate
    user_number = params[:user_number]
    otp = rand(100_000..999_999).to_s

    $otp_global ||= {}
    $otp_global[user_number] = {
      otp: otp,
      expires_at: 5.minutes.from_now
    }

    render json: {
      otp: otp,
      message: 'Successfully sent the OTP to SMS.'
    }, status: :ok
  end

  def verify
    user_number = params[:user_number]
    user_otp = params[:otp]

    otp = $otp_global&.[](user_number)&.[](:otp)
    expires_at = $otp_global&.[](user_number)&.[](:expires_at)

    if user_otp == otp && expires_at > Time.now
      render json: {
        verify: 'success',
        message: 'Successfully verified the OTP.'
      }, status: :ok
    else
      render json: {
        verify: 'failed',
        message: 'The OTP is invalid/expired.'
      }, status: :unauthorized
    end
  end
end
