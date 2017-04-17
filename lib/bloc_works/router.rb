module BlocWorks
  class Application

    def controller_and_action(env)
      _, controller, action, _ = env["PATH_INFO"].split("/", 4)
      controller = controller.capitalize
      controller = "#{controller}Controller"

     {controller: Object.const_get(controller), action: action}
    end

    def fav_icon(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end
    end
  end
end
