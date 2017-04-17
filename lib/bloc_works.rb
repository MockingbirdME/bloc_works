require "bloc_works/version"
require "bloc_works/dependencies"
require "bloc_works/controller"
require "bloc_works/router"
require "bloc_works/utility"

module BlocWorks

  class Application
    def call(env)
      controllerAndAction = self.controller_and_action(env)
      controller = controllerAndAction[:controller].new(env)
      action = controllerAndAction[:action]


      [200, {'Content-Type' => 'text/html'}, [controller.public_send(action)]]
    end
  end

end
