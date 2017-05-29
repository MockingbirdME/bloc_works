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

    def route(&block)
      @router ||= Router.new
      @router.instance_eval(&block)
    end

    def get_rack_app(env)
      if @router.nil?
        raise "No routes defined"
      end
      p '+++++++++++++++++==================+++++++++++++++++++'
      p env["PATH_INFO"]
      p @router.look_up_url(env["PATH_INFO"])
      @router.look_up_url(env["PATH_INFO"])
    end

  end

  class Router
   def initialize
     @rules = []
   end

   def resources(resource_controller)
     map "", "#{resource_controller}#welcome"
     map ":controller/:id/:action"
     map ":controller/:id", default: {"action" => "show"}
     map ":controller", default: {"action" => "index"}
   end

   def format_args(*args)
     args = args[0] if args.length === 1
     formated_args = []
     if args[-1].is_a?(Hash)
       formated_args.push(args.pop)
     else
       formated_args.push({})
     end
     formated_args[0][:default] ||= {}
    #  args.size > 0 ? formated_args.push(args.pop) : formated_args.push(nil)
     formated_args.push(args.pop) if args.size > 0
     p formated_args
     p formated_args[1]
     formated_args.push(args.pop) if args.size > 0
     formated_args
   end

   def get_parts(url)
      parts =url.split("/")
      parts.reject! { |part| part.empty? }
      parts
   end

   def get_vars_and_regex(parts)
     vars, regex_parts = [], []

     parts.each do |part|
       case part[0]
       when ":"
         vars << part[1..-1]
         regex_parts << "([a-zA-Z0-9]+)"
       when "*"
         vars << part[1..-1]
         regex_parts << "(.*)"
       else
         regex_parts << part
       end
     end

     regex = regex_parts.join("/")
     [vars, regex]
   end

   def map(url, *args)
     p "%%%%%%%%%%%%%%%%%%%%%%%%%%% in map %%%%%%%%%%%%%%%%%%%%%%"
     p args
     formated_args = format_args(args)
     raise "Too many args!" if formated_args.length > 2
     options = formated_args[0]
     destination = formated_args[1]
     parts = get_parts(url)
     var_and_regex_arr = get_vars_and_regex(parts)
     vars = var_and_regex_arr[0]
     regex = var_and_regex_arr[1]

     @rules.push({ regex: Regexp.new("^/#{regex}$"),
                   vars: vars, destination: destination,
                   options: options })
    end

    def get_params(rule, rule_match, options)
      params = options[:default].dup

      rule[:vars].each_with_index do |var, index|
        params[var] = rule_match.captures[index]
      end
      params
    end

    def look_up_url(url)
      @rules.each do |rule|
        rule_match = rule[:regex].match(url)

        if rule_match
          options = rule[:options]
          params = get_params(rule, rule_match, options)

          unless rule[:destination]
            rule[:destination] = "#{params["controller"]}##{params["action"]}"
          end

          return get_destination(rule[:destination], params)

        end
      end
    end

    def get_destination(destination, routing_params = {})
      p "*********************** in get_destination **************"
      p destination
      if destination.respond_to?(:call)
        return destination
      end

      if destination =~ /^([^#]+)#([^#]+)$/
        name = $1.capitalize
        controller = Object.const_get("#{name}Controller")
        return controller.action($2, routing_params)
      end
      raise "Destination not found: #{destination}"
    end

  end
end
