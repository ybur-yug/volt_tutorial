# Volt User Templates

Volt user templates provide out of the box templates for users to signup, login, and logout.  (Forgot password coming soon)

## Install

volt-user-templates now ships with volt, but if you have removed it, you can add it back with the following:

In your Gemfile, put:

```ruby
gem 'volt-user-templates'
```

Then in any component you want to use the templates in, add the following to config/dependencies.rb

```ruby
component 'user-templates'
```

## Use

You can use volt-user-template two different ways.

1) You can add routes for it's templates

Add the following to your main components route file:

```ruby
get '/signup', _controller: 'user-templates', _action: 'signup'
get '/login', _controller: 'user-templates', _action: 'login'
```

Now you can link to /signup and /login

2) You can include the templates as tags:

### Login

```html
<:user-templates:login post-login-url="/" />
```

The login template takes an optional post-login-url that will be redirected to after a successful login.

### Signup

```html
<:user-templates:signup post-signup-url="/" />
```

Signup takes an optional post-signup-url that will be redirected to after signup.

### Logout

volt-user-templates provides a nav bar tag that provides a login/logout link and shows the users name.

```html
<:user-templates:menu />
```