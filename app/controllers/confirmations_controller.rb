class ConfirmationsController < Devise::ConfirmationsController
	def new
		super
	end

	def create
		super
	end

	def show
      	User.find_by_confirmation_token(params[:confirmation_token]).update_attribute("status_id", 1) unless params[:confirmation_token].nil?
		super
	end

end 