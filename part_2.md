## Getting Started

#### Note, this can be skipped using the provided [Dockerfile](link) if you so desire.

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

`editor config/app.rb`

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
#### [commit f9b0f336bba3d90049242261e2dc4e9f0b17f639](http://www.github.com/rhgraysonii/volt_tutorial/commit/f9b0f336bba3d90049242261e2dc4e9f0b17f639)

Note that we have only added the README. Everything else is still not staged or indexed at
all. Their creation has been noticed, but not noted. However, since we have moved
our secret out and we know the base application is functional we may now add all 
the directories and files included by default.

`git add app  config  config.ru Gemfile lib  README.md  spec`

`git commit -m 'initial working build'`

#### [commit 8d5b14742e172a2f82ad9acfdefe816b5bbd5b4a](http://www.github.com/rhgraysonii/volt_tutorial/commit/8d5b14742e172a2f82ad9acfdefe816b5bbd5b4a)

Now, lets dive in deeper and take a look at how we can start adding some models and get
functionality going on top of these simple users we can already have sign up and log
in.

[Your First App](part_3.md)
