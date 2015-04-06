module UserTemplates
  class SignupController < Volt::ModelController
    def index
      self.model = store._users.buffer
    end

    def signup
      # Get login and password to login
      login = model.send(:"_#{User.login_field}")
      password = model._password

      save!.then do |result|
        flash._notices << "Signup successful"

        post_signup_url = attrs.post_signup_url.or('/')

        # On a successful signup, then login
        Volt.login(login, password).then do
          # Redirect to post signup url
          go post_signup_url
        end.fail do |errors|
          # Show the error (probably only the server goes down)
          flash._errors << errors.to_s
        end
      end.fail do |err|
        puts "ERR: #{err.inspect}"
      end
    end

    def use_username?
      Volt.config.public.try(:auth).try(:use_username)
    end

  end
end
