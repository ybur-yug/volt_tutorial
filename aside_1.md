# Aside 1

## Understanding Controllers, Parameters, Template Bindings, and Views
Volt has a wonderful system for managing relations between all the components that make up the application. Here we will go 
through a variety of examples with the endgame goal being to truly grok the system that powers all of these interactions under
the hood. No one likes relying on 'magic'.

## Beginning
The core of a Volt application is the `main` component. The views inside of Volt are nested, and can be done so infinitely.
Much like render in Rails, except its how layouts are handled. So inside our `main` component we can have `blog` or anything else, 
and continue to nest from there. 

In Volt it starts with the URL. From there, we are pulling a set of parameters. Routes map the url to this. We then use this
to make a path string that is passed to the template binding, which then maps it to a view file, and this results in hte
relevent controller and view also being lodaed. In there is controllers and actions, but in Volt, the path string controls
the actions taking place. If we open a freshly generated Volt application and open `app/main/views/main/index.html` and add

```RUBY
<input value='{{ params._name }}'>
<input value='{{ params._name }}'>
```

We can input values into those, and they will not only sync with each other but the URL as well. Also note that if you change
the parameters in the URL it is then reflected in the input boxes. This is the most basic example of how Volt's binding works.

## Routes

```RUBY
get '/user/{{ params._name }}', _action: 'user_page'
```

Now, we can go to `/user/some_name` and it will direct us properly to that controller. This would then assign the parameters
to the user_page controller and template. Any time parameters are changed it goes from top to bottom through routes and 
matches the first one that matches all of the given properties.

```RUBY
get '/blog', _controller: 'blog', _action: 'index'
get '/blog/{{ _id }}', _controller: 'blog'

```

This will set up a route for `/blog` that is managed by the `blog_controller` and performs the `index` action.
The parameters are soo interpreted into a path string. There is a `main_path` method set in `main_controller` by default
and it goes in and defaults to main unless it has something outside `main` and `index`. If we look at our views, we see it
is `main/` holding what we have thus far. From here, we can nest our main templates. It will first render the main path, and
the template binding lookup algorithm now goes down through all the files finding a match for the action and controller that
is currently being called by the application.

The controller and view folder names should always have the same nesting and naming. If we went to `/blog` it would then
render the blog view with the relevent controller, and call the `index` method and look up the `index` view. As soon as 
these parameters change a new path is set and the controller changes if needed.

|Component    |View Folder  |View File  |Section            
|---    |---    |---    |---
|x      |x  |x   |index
|x      |x  |index   |body
|x      |index  |index   |index
|x      |index  |index   |body
|index      |main  |index   |body

If we are rendering inside of main, and we pass in index, it will look in order through the table until it matches.
You see as it traverses down, it simply is looking to match the pieces together the first chance it has. 

So, all in all
Url -> Parameters -> Path String -> Templating Binding -> Controller -> View

Hopefully this helps demystify some of the inner workings a bit for you.
