# How to Volt - From 0 to 60
#### Note: This is a WIP

## Introduction
Hi. You're a developer, or someone interested in writing some code. A web app even! This is fun. Awesome.
We're going to learn about Volt today. Volt is a web framework that allows us to write applications in which
the client and server are perfectly synced at all times. Reactivity! Woo! It is also powered by [Opal](link) so that all of our code can be in Ruby, client and server both!

## Why Volt?
#### Note: This is a rough retelling of [@ryanstout](link)'s talk at Rubyconf.

Web Development has hit a trend that has shown it's head in the past.This pattern, like
many others, is a possible indication that history oft repeats itself. Back in the early
Rails days, we basically just rendered HTML. This previously was done by a large amount
of patch work, and led to a bunch of bad patterns and things glued together. Rails took
the previous ten years of doing this and found an abstraction for it. It did this 
using an MVC model. 

Moving into the years ahead, Gmail came around, and AJAX became a buzzwork. Asynchronous
JavaScript essentially boiled down to, "Hey, lets get some new data without doing an 
entirely new get request.". Rails standardized on REST and JSON, and skip to 2009 and
we've a new problem. We are sending so much JS and CSS to the client that Rails needed
to introduce the asset pipeline. Now, a bit more time elapses and there is full clientside
MVC with tools like Bower to manage all of them. The number of tools in this stack has
spread like wildfire due to a variety of factors.

Lets take a look at the elements of complexity in the server and clientside that are now
part of the standard Rails/Ember or Rails/Backbone, etc. stack:

|client              |server
|---                 |---
|asset leading       | asset packing
|routes/auth         | routes/auth
|models              | models
|controllers         | controllers
|views               | views
|AJAX                | REST

[The Pragmatic Programmer](link) said

```
DRY—Don’t Repeat Yourself
Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
```

It would appear as if we are disappointing sensei with this design pattern. But what
is the core issue here? Theoretically, this could be as 'simple' as a massive refactoring. 
Work utilizing abstraction to couple. This, however,would be insane. 

There is a word in mathematics, isomorphic

```
i·so·mor·phic
adjective: isomorphic; adjective: isomorphous
    corresponding or similar in form and relations.
```

It would seem that our client and server could potentially be developed for isomorphically.
This is currently the term Volt uses for this style of design -- shared code between client
and server. Rather than the replication we currently are forcing ourselves into.

People who are new to web development that encounter these patterns often see this and
feel like it is crazy. What is the solution?

Well, we hope it is isomorphic development with Volt.

Now instead of REST and JSON, communicating over all these API's we can simply have the
code be shared between client and server. And also, with the use of websockets, we can
update everything and have it live sync across multiple clients. Reactivity batman!

How is the frontend JavaScript removed? [Opal](link). Volt gives us a bunch of toys
we normally are given in a frontend framework that lets us build fast and quick.
You get automatic simple bindings inside the frontend, automatic bindings, syncing
with the database, or all clients. 

Volt also builds all apps as nested components. Rather than allowing a monolithic application
to build itself up, as many Rails/JS projects tend to, Volt instead tries to keep things
inside reuseable chunks that are easily managed and picked and chosen.

A trend of recent years has seemingly been 'compile to JavaScript'. Why did this come up?
What is it about the language that it is so hard to build in that programmers continuously
are building layers of abstraction to escape it?

Douglas Crockford, author of 'JavaScript: The Good Parts' recently said in a talk:

- Don't use `new`
- Don't use `Object.create`
- Don't use `this`
- Don't use `null`
- Dont use falsiness

It would appear that this completely removes the object-oriented and prototypal design
patterns of the language, in favor of writing purely functionally. It would appear
that if you are leaving the largest patterns of design that are core to the language's
unique features, that something may be able to do better. I have written JavaScript for
years, and it is a language I loved in the beginning but as I grew as a developer I
fell further and further into the backend.

Opal has gained a large foothold, and development is going well. Many think that compiling
to JavaScript will be incredibly complex and difficult, but it works quite reliably. This
reliability is akin to a C developer not needing to know what specific memory register 
something is on for a large-scale task. Opal also adds little overhead as far as filesize.

Debugging in Opal actually is quite nice. While many other languages compile to bytecode
and use a VM, it transpiles the concepts and maps them 1:1. This is valid, transpilable
Opal:

```RUBY
class Foo
  def initialize(name)
    @name = name
  end
  
  def welcome
    "hi #{name}"
  end
end
```

The source maps also give you stack traces directly back to Ruby, rather than JavaScript.
No more worrying about `undefined is not a function`. They are also quite brief. IRB is
also able to be ran in the browser with IRB. Opal is also tested with RubySpec, so one
knows its a faithful implementation. Opal and MRI will have the same error 99% of the
time. Opal does have a small overhead, but it is not a ton of it and the gains are huge.

Opal does lack math abilities due to its customized use of operators. However, at anytime
with a backtick (\`) lets you inline vanilla JS.

On top of Opal for the frontend, volt also gives you Collections. They are:
- Page
- Params
- Store
- Local Store
- Cookies

Page is temporary memory
Store is the DB/other user sync
Params is the URL parameters
Local store and cookies are less important to consider right now.The normal MVC
paradigm is not how Volt handles its design patterns. Volt follows what is popularly
referred to as the MVVM pattern. This breaks down into three core concepts:

The model, which is as one may expect a simple object representing something in our application.
The view, which is the view and instances of data rendered to the client.
The view-model, which is functionally a controller of sorts. But it starts with a view, and any
time a binding hits a method is called to the controller and it can respond.

At any point if the data changes, frontend or back, the method will be called again and the data
will be persisted.

Volt also does automatic code push, so any save results in an automatic reload of the server while
developing. The component-centric system also allows for `Tags` to be carried into the new code
utilizing the other components functionalities. A simple example of this would be this:
Lets say we have a simple to do list.If we create a buffer to hold data in the interim before we
update a model, we now can change how we save. We declaratively state the save, and if it passes
we can push the success. Now, if we add a component to the list, `volt-fields`, we can add in
its functionality in the todo list's submission via `volt-fields`'s tag, and now we get free
validations with success/error feedback in real time just by binding this tag and having it
set through the model using a buffer.

Tasks are another wonderful piece of Volt. It allows you to call serverside code in an RPC fashion
so that a promise is returned sharing error/success messages and data returned. This allows
asynchronous work very simple.

By having one language, one router, central state, component extension, and automatic
reactivity, Volt provides something in a simple package that is hard to find a real competitor
for. So let's dig in.

## Getting Started
I will treat this tutorial as a system for someone with 0 configuration coming in. So we will cover 'basic' things
such as managing Ruby versions, using bundler, and generally configuring an environment for development.

## Lets Get Ruby
First step to making a Ruby app is to install Ruby. I will primarily cover Linux and OSX options here, but
for Windows users, just ensure you install Ruby 2.2.0. We will worry about Ruby versions for that platform
later. For managing Ruby on Linux and OSX, I prefer [rbenv](link).

To install it, directions are easily followed [here](https://github.com/sstephenson/rbenv#installation).

Once rbenv is configured we will want to work with the latest stable version of Ruby. In this case, 
it is 2.2.0. To get it,

`rbenv install 2.2.0`

We also will need bundler to manage our gems:

`gem install bundler`

## On to the Volt Train
This will take a moment, but when complete we can now move on and install Volt.

`gem install volt`

Now, we have Ruby, and a web application development framework. Lets get things rolling.

`volt new baller_app`

I have decided on Baller App for my app name. You may pick something equally trivial and senseless,
or spend hours trying to name it. Your call.

#### NOTE: from here on `baller_app` will be substituted with `appname`

```
cd appname
ls
#=> app  config  config.ru Gemfile  Gemfile.lock  lib  README.md  spec`
```

Now, we will want to set out Ruby version to 2.2.0, since we have gotten into the working directory.

`rbenv local 2.2.0`

Lets examine the archicture of the application. Much like Ruby on Rails, we have a Gemfile.
We also clearly have a working directory for tests, library code, configuration, and
a README. Seems simple enough! Let's see what we get for free with a boilerplate project,
and while were at it lets explore Volt's CLI tools.

```
volt
#=> Volt 0.8.26
Commands:
volt console                    # run the console on the project in the current directory
volt gem GEM                    # Creates a component gem where you can share a component
volt generate GENERATOR [args]  # Run a generator.
volt help [COMMAND]             # Describe available commands or one specific command
volt new PROJECT_NAME           # generates a new project.
volt precompile                 # precompile all application assets
volt runner FILEPATH            # Runs a ruby file at FILEPATH in the volt app
volt server                     # run the server on the project in the current directory
```

So it seems we have a console, an generators, a server, and some things that look like they
are a little more in depth. Running the server will let us check out the boilerplate app.
Let's bundle up our gems and fire this bad thang up.

```
bundle
bundle exec volt server
```
You should see some cool ascii art pop up, and it informs us we should sniff around port 3000,
so to grandmother's port we go. If we check out the page in our browser, it appears that we have
the ability to make accounts and log in/out, an about page, and a home page. Not bad! Let's
open up the project in your editor of choice and dig deeper. 

NOTE: `editor file_name` is what I will refer to for editing. If you are using an IDE,
or something else that isn't working off the CLI, just grab the folder and drop it in the app.
This will let you browse the file tree in almost any text editor.

Opening `app.rb` seems logical, since we are building an app after all. Let's check that out.

`editor config/base/app.rb`

It seems this holds out default generated `app_secret`, as well as any other global configuration.
There are also compression, server, and database options. But we need not worry about all that
right now. For the moment, lets just do a simple security move and move this generated secret
from the file here, to a configured environment variable. This way the secret is never leaving
the server, and will also be absent from the repository's code. If you are a unix user, env
vars should not be a foreign concept. 

Personally, I keep project specific dotfiles for these 
named in the style `.appname_vars`. So, `editor .appname_vars` and lets set it. Delete the
string from `app.rb` and paste it in as:

`export APPNAME_SECRET='whatever_the_generated_string_was'`

Write that and open `app.rb` and we are able to replace 

`config.app_secret = 'whatever_it_generated'`

with

`config.app_secret = ENV['APPNAME_SECRET']`

and once we source it, we have securely removed it from the codebase:

`source .appname_vars`, and we are golden.

Now, we should initialize a git repository and make our initial commit.

```
git init
git add README.md
git commit -m 'initial commit'
```

Note that we have only added the README. Everything else is still not staged or indexed at
all. Their creation has been noticed, but not noted. However, since we have moved
our secret out and we know the base application is functional we may now add all 
the directories and files included by default.

`git add app  config  config.ru Gemfile lib  README.md  spec`

`git commit -m 'initial working build'`

Now, lets dive in deeper and take a look at how we can start adding some models and get
functionality going on top of these simple users we can already have sign up and log
in.


## Getting Started
Volt applications are built with nested components. Out of the box you get one component
named main, and can easily include and package others. 

`volt console`

Now, we have our default console. If we check what's up, we will see we are accessing
`Volt::Page`. If we call `page.attributes` we can see we get a hash back that is something
like `{:name-><Volt::Model::some_id nil>}`. So by default, we are manipulating a page.

Let's start our list now. Lets create a file called `todos.html` in `app/main/views/main/`
that looks like this:

```HTML
<:Title>
  Todos
<:Body>
  <h1>Todos</h1>
```

Now let's add a link to todos in our nav in `/views/main/main.html`, the skeleton of our
frontend:

```HTML
<:nav href="/todos">Todos</:nav>
```
on `line 10`

Now, the application has this route established as a way to traverse the page on the
frontend, but we need to work on the backend to support this as well. Let us open up
`app/main/config/routes.rb` and add the line:

`get '/todos', _action: 'todos'`

This will allow the server to recognize this path. If we check out the current page,
we can now click our way through to the todo page. Next, we'll need a form to submit
them from the clientside. open up `app/main/views/main/todos.html` and we can add this
block below our `h1` tags:

```HTML
<form e-submit="add_todo" role="form">
  <div class='form-group'>
    <label>Todo</label>
    <input class="form-control" type="text" value="{{ page._new_todo }}">
  </div>
</form>
```
`line 6`

The braces allow us to execute ruby code on both the client and server, so
we are binding to the value to a member of the collectoin `page`, that we
referenced earlier in the introduction. `page` is a temporary collection, so 
upon refresh this value will not be persisted. Since any value bound will
be updated, we can add a method to `app/main/controllers/main_controller.rb`
to get the value there. So, heres our `add_todo` method:

```RUBY
def add_todo
  page._todos << { name: page._new_todo }
  page._new_todo = ''
end
```
`line 11`

We are sending a hash to page that will contain the name of the new todo from
the form when this method is called by the client. We then clear it out so
another todo may be added to the list. To see these we will add a table to
our page:

```HTML
<table class="todo-table">G
  {{ page._todos.each do |todo|
    <tr>
      <td>{{ todo._name }}</td>
    </tr>
  {{ end }}
</table>
```
`line 13`

## Building A Simple View
## Adding Controller Bindings
## Adding Controller Logic
## Beyond Todos: Bookmarking
## Validations
## Model Relations
## Adding Tasks
