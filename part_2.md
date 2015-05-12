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
# TODO
```

So it seems we have a console, an generators, a server, and some things that look like they
are a little more in depth. Running the server will let us check out the boilerplate app.
Let's bundle up our gems and fire this bad thang up.

```
bundle
bundle exec volt server
```
TODO'

Now, we should initialize a git repository and make our initial commit.

```
git init
git add README.md
git commit -m 'initial commit'
```
[Your First App](part_3.md)
