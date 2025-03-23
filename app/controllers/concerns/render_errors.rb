module RenderErrors
  extend ActiveSupport::Concern

  private

  def render_not_found(message = t("shared.message.error.not_found"))
    respond_to do |format|
      format.html { redirect_to root_path, alert: message }
      format.json { render json: { error: message }, status: :not_found }
    end
  end
end
