require 'rails/railtie'

module UserNotif
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      ActiveSupport::Dependencies.autoload_paths += %W(#{app.root}/app/models/notifications)
    end

    initializer 'user_notif.view_helpers' do
      ActionView::Base.send :include, UserNotif::ViewHelpers
    end
  end
end
