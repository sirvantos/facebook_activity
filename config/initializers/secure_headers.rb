::SecureHeaders::Configuration.configure do |config|
  config.hsts = {:max_age => 20.years.to_i, :include_subdomains => true}
  config.x_frame_options = 'DENY'
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = {:value => 1, :mode => 'block'}
  config.csp = {
      default_src: "self https://* http://*.googleapis.com http://*.facebook.com http://*.facebook.net http://*.google.com http://*.googlecode.com http://*.gstatic.com",
      style_src: "self 'unsafe-inline' https://* http://*.googleapis.com http://*.facebook.com http://*.google.com http://*.googlecode.com http://*.gstatic.com",
      script_src: "self 'unsafe-inline' 'unsafe-eval' https://*  http://static.ak.facebook.com http://*.googleapis.com http://*.facebook.com http://*.facebook.net http://*.google.com http://*.googlecode.com http://*.gstatic.com",
      # # object_src: "self"
      # # connect_src: "https://* self http://*.googleapis.com http://*.facebook.com/* http://*.google.com/*",
      # frame_src: "self",
      # # img_src: "https://* self http://*.googleapis.com http://*.facebook.com/* http://*.google.com/*"
      # # report_uri: '//example.com/uri-directive'
  }
end