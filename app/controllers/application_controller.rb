class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!

  def authorize_user
    redirect_to root_path, alert: 'No tienes permisos para acceder a esta sección.' unless current_user&.librarian?
  end
end
