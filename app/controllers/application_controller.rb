class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!

  def authorize_user
    redirect_to root_path, alert: "You don't have permission to access this section." unless current_user&.librarian?
  end
end
