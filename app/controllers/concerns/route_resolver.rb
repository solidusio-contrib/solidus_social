module RouteResolver
  extend ActiveSupport::Concern

  # Added an explicit lookup to the main_app for missing routes in case of starter frontend
  def resolve_route_for(route)
    if respond_to?(:spree) && spree.respond_to?(route)
      spree.public_send(route)
    else
      main_app.public_send(route)
    end
  end
end
