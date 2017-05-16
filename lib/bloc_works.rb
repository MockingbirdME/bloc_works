require "bloc_works/version"
require "bloc_works/dependencies"
require "bloc_works/controller"
require "bloc_works/router"
require "bloc_works/utility"
require "bloc_works/controller"

module BlocWorks

  class Application
    def call(env)
      # controllerAndAction = self.controller_and_action(env)
      # controller = controllerAndAction[:controller].new(env)
      # action = controllerAndAction[:action]
      #
      #
      # # [200, {'Content-Type' => 'text/html'}, [controller.public_send(action)]]
      #
      # if controller.has_response?
      #   status, header, response = controller.get_response
      #   [status, header, [response.body].flatten]
      # else
      #   [200, {'Content-Type' => 'text/html'}, [controller.public_send(action)]]
      # end
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      rack_app = get_rack_app(env)
      rack_app.call(env)
    end
  end

end
