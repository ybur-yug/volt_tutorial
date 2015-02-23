# How to Volt - From 0 to 60

## Introduction
Hi. You're a developer, or someone interested in writing some code. A web app even! This is fun. Awesome.
We're going to learn about Volt today. Volt is a web framework that allows us to write applications in which
the client and server are perfectly synced at all times. Reactivity! Woo! It is also powered by Opal [add link]
so that all of our code can be in Ruby, client and server both!

## Why Volt?
I love Meteor.js. I also am not the biggest fan of JavaScript as a whole. Thus, Volt seemed to be a great avenue
to have these capabilities without having to deal with `undefined is not a function`.

## Getting Started
I will treat this tutorial as a system for someone with 0 configuration coming in. So we will cover 'basic' things
such as managing Ruby versions with rbenv, setting up and using bundler, and generally configuring an environment
for Ruby development.

## Lets Get Ruby
First step to making a Ruby app is to install Ruby. I will primarily cover Linux and OSX options here, but
for Windows users, just ensure you install Ruby 2.2.0. We will worry about Ruby versions for that platform
later. For managing Ruby on Linux and OSX, I prefer [rbenv](link).

To install it, directions are easily followed here:
https://github.com/sstephenson/rbenv#installation

No point in rewriting the tutorial when it is perfectly precise and tested. So, once rbenv is configured
we will want to work with the latest stable version of Ruby. In this case, it is 2.2.0. To get it,

`rbenv install 2.2.0`

We also will need bundler to manage our gems:

`gem install bundler`

## On to the Volt Train
This will take a moment, but when complete we can now move on and install Volt.

`gem install volt`

Now, we have Ruby, and a web application development framework. Lets get things rolling.

`volt new veddit`

I have decided on Veddit for my app name. You may pick something equally trivial and senseless,
or spend hours trying to name it. Your call.

NOTE: from here on `veddit` will be substituted with `appname`

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
the server, and will also be absent from the repository's code. If you are a *nix user, env
vars should not be a foreign concept. Personally, I keep project specific dotfiles for these 
named in the style `.appname_vars`. So, `editor .your_var_fn` and lets set it. Delete the
string from `app.rb` and paste it in as:

`export APPNAME_SECRET='whatever_the_generated_string_was'`

Now, in `app.rb` we are able to replace 

`config.app_secret = 'whatever_it_generated'`

with

`config.app_secret = ENV['APPNAME_SECRET']`

and once we source it, we have securely removed it from the codebase:

`source .your_var_fn`, and we are golden.

Now, we should initialie a git repository and make our initial commit.

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

## Getting Started With Models
We want to have a way to simply submit a link to our page. This encompasses a few tasks:
First, we will need to make the model. We will also need to establish its applicable 
behaviours somewhere, and then proceed to also have a page to view all these link
models. So, lets start by exploring in the console a bit. 

`volt console`

Now, we have our default console. If we check what's up, we will see we are accessing
`Volt::Page`. If we call `page.attributes` we can see we get a hash back that is something
like `{:name-><Volt::Model::some_id nil>}`. So by default, we are manipulating a page.
If modifying a page is where we start to work by default, if we want to add a page for
links, we best get it in our routes. So lets open that up.

`editor app/main/config/routes.rb`

We want to specify a route to GET for our application. So, we shall now add
```
get "/todos/{{_index}}", _action: 'todos'
get "/todos", _action: 'todos'
```

This will let us get our todos at the current `_index` as well as have a general
route for them. 

Now what controls the route? Well, a controller sounds like a good place to start.

## Controllers and Simple Logic
WIP...

