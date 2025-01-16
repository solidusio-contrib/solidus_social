module RouteResolver
  extend ActiveSupport::Concern

  # An explicit lookup to the main_app for missing routes in case of starter frontend
  def resolve_route_for(route)
    if respond_to?(:main_app) && main_app.respond_to?(route)
      main_app.public_send(route)
    else
      public_send(route)
    end
  end
end
