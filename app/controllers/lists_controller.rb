class ListsController < ApplicationController

  def index
    begin
      @user = User.last
      @api_key = @user.api_key
      @mc = Mailchimp::API.new(@api_key)
      lists_res = @mc.lists.list
      @lists = lists_res['data']
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "An unknown error occurred"
      end
      redirect_to edit_user_path(@user)
    end
  end

  def view
    list_id = params[:id]
    begin
      @user = User.last
      @api_key = @user.api_key
      @mc = Mailchimp::API.new(@api_key)
      lists_res = @mc.lists.list({'list_id' => list_id})
      @list = lists_res['data'][0]
      members_res = @mc.lists.members(list_id)
      @members = members_res['data']
    rescue Mailchimp::ListDoesNotExistError
      flash[:error] = "The list could not be found"
      redirect_to "/lists/"
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "An unknown error occurred"
      end
      redirect_to "/lists/"
    end
  end

  def show
    list_id = params[:id]
      @user = User.last
      @api_key = @user.api_key
      @mc = Mailchimp::API.new(@api_key)
      lists_res = @mc.lists.list({'list_id' => list_id})
      @list = lists_res['data'][0]
      members_res = @mc.lists.members(list_id)
      @members = members_res['data']

      respond_to do |format|
        format.html
        format.csv do
          headers['Content-Disposition'] = "attachment; filename=\"member-list\""
          headers['Content-Type'] ||= 'text/csv'
        end
      end

  end
end
