module SolidusSocial
  # Patch the Facebook strategy discriminating between mobile and desktop.
  module FacebookOmniauthStrategyExt
    MOBILE_USER_AGENTS = "palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|" \
                          "audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|" \
                          "x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|" \
                          'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' \
                          "webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|" \
                          "mobile"

    def request_phase
      options[:scope] ||= "email"
      options[:info_fields] ||= "email"
      options[:display] = mobile_request? ? "touch" : "page"
      super
    end

    def mobile_request?
      ua = Rack::Request.new(@env).user_agent.to_s
      ua.downcase =~ Regexp.new(MOBILE_USER_AGENTS)
    end

    OmniAuth::Strategies::Facebook.prepend self
  end
end
