require 'mailchimp'

class PagesController < ApplicationController
  def home
    begin
      @user = User.last
      @api_key = @user.api_key
      @mc = Mailchimp::API.new(@api_key)
      res = @mc.helper.ping
    rescue Mailchimp::InvalidApiKeyError => ex
      flash[:error] = "The API key is invalid."
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "An unknown error occurred"
      end
    end
  end
end
