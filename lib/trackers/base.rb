class Trackers::Base
  def base_address
    ENV.fetch("TRACKERS_BASE_URL")
  end
end
