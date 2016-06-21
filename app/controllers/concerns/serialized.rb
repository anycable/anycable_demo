module Serialized
  extend ActiveSupport::Concern

  def render_json(item, root_name = controller_name.singularize)
    if item.errors.any?
      render_errors item
    else
      render json: item, root: root_name, meta_key: :message, meta: t('.message')
    end
  end

  def render_json_message
    render json: { message: t('.message') }
  end

  def render_errors(object)
    render text: object.errors.full_messages.join("<br/>"), status: :forbidden
  end

  def render_not_found
    render status: :not_found
  end
end
