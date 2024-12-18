module SolidusSupport
  class << self
    # Currently it checks only legacy frontend support
    # enabling this here for starter frontend to load missing routes and controllers
    def frontend_available?
      true
    end
  end
end
