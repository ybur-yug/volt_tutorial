module UserTemplates
  class MenuController < Volt::ModelController
    def show_name
      user = Volt.user
      user._name.or(user._email).or(Volt.user._username)
    end
  end
end