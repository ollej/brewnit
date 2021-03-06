module MediaConcern
  extend ActiveSupport::Concern

  def load_parent
    case
      when params[:recipe_id] then Recipe.find_by_id(params[:recipe_id])
      when params[:user_id] then User.find_by_id(params[:user_id])
      when params[:event_id] then Event.find_by_id(params[:event_id])
    end
  end
end
