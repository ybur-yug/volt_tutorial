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

## On to the Volt Train
This will take a moment, but when complete we can now move on and install Volt.

`gem install volt`

Now, we have Ruby, and a web application development framework. Lets get things rolling.

`volt new veddit`

I have decided on Veddit for my app name. You may pick something equally trivial and senseless,
or spend hours trying to name it. Your call.

NOTE: from here on `veddit` will be substituted with `app_name

```
cd app_name
ls
#=> app  config  config.ru Gemfile  Gemfile.lock  lib  README.md  spec`
```
