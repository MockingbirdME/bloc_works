require "bloc_works/version"
require "bloc_works/dependencies"
require "bloc_works/controller"
require "bloc_works/router"
require "bloc_works/utility"

module BlocWorks

  class Application
    def call(env)
      controllerAndAction = self.controller_and_action(env)
      controller = controllerAndAction[0].new(env)
      action = controllerAndAction[1]


      [200, {'Content-Type' => 'text/html'}, [controller.send(action)]]
    end
  end

end
