module AccessControl

  def set_access_control_headers
    allowed_origins = %w(http://www.zoopla.co.uk http://www.rightmove.co.uk)
    origin = request.env['HTTP_ORIGIN']

    if allowed_origins.include? origin
      headers['Access-Control-Allow-Origin'] = origin
      headers['Access-Control-Request-Method'] = '*'
    end

  end
end