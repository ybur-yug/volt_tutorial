## Why Volt?
> **Note: This is a rough retelling of [@ryanstout](link)'s talk at Rubyconf.**

Web Development has hit a trend that has shown it's head in the past. This pattern, like many others, is a possible indication that history oft repeats itself. 

Back in the early Rails days, we basically just rendered HTML. This previously was done by a large amount of patch work, and led to a bunch of bad patterns and things glued together.

Rails took the previous ten years of doing this and found an abstraction for it. It did this using an MVC model. 

Moving into the years ahead, Gmail came around, and AJAX became a buzzwork. Asynchronous
JavaScript essentially boiled down to, "Hey, lets get some new data without doing an 
entirely new get request". 

Rails standardized on REST and JSON, and skip to 2009 and we've a new problem. We are sending so much JS and CSS to the client that Rails needed to introduce the asset pipeline. 

Now, a bit more time elapses and there is full clientside MVC with tools like Bower to manage all of them. The number of tools in this stack has spread like wildfire due to a variety of factors.

Lets take a look at the elements of complexity in the server and clientside that are now a part of the standard Rails/Ember or Rails/Backbone, etc. stack:

|client              |server
|---                 |---
|asset leading       | asset packing
|routes/auth         | routes/auth
|models              | models
|controllers         | controllers
|views               | views
|AJAX                | REST

[The Pragmatic Programmer](link) said

> DRY—Don’t Repeat Yourself  
Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.

It would appear as if we are disappointing sensei with this design pattern. But what is the core issue here? 

Theoretically, this could be as 'simple' as a massive refactoring. Work utilizing abstraction to couple. This, however,would be insane. 

There is a word in mathematics, isomorphic

> i·so·mor·phic  
adjective: isomorphic; adjective: isomorphous  
    corresponding or similar in form and relations.

It would seem that our client and server could potentially be developed for isomorphically.

This is currently the term Volt uses for this style of design -- shared code between client and server. Rather than the replication we currently are forcing ourselves into.

People who are new to web development that encounter these patterns often see this and feel like it is crazy. What is the solution?

Well, we hope it is isomorphic development with Volt.

Now instead of REST and JSON, communicating over all these API's we can simply share the code between the client and server. With the use of websockets we can update everything and have it live sync across multiple clients. 

That's [reactivity](http://reactivex.io/), Batman!

How is the frontend JavaScript removed? [Opal](https://github.com/opal/opal). 

Volt gives us a bunch of toys we normally are given in a frontend framework that lets us build fast and quick. You get automatic simple bindings inside the frontend, automatic bindings, syncing with the database, or all clients. 

Volt also builds all apps as nested components. Rather than allowing a monolithic application to build itself up, as many Rails/JS projects tend to, Volt instead tries to keep things inside reuseable chunks that are easily managed and picked and chosen.

A trend of recent years has seemingly been 'compile to JavaScript'. Why did this come up? What is it about the language that it is so hard to build in that programmers continuously are building layers of abstraction to escape it?

Douglas Crockford, author of 'JavaScript: The Good Parts' recently said in a talk:

- Don't use `new`
- Don't use `Object.create`
- Don't use `this`
- Don't use `null`
- Dont use falsiness

It would appear that this completely removes the object-oriented and prototypal design
patterns of the language, in favor of writing purely functionally. 

It would appear that if you are leaving the largest patterns of design that are core to the language's unique features, that something may be able to do better. 

I have written JavaScript for years, and it is a language I loved in the beginning but as I grew as a developer I fell further and further into the backend.

Opal has gained a large foothold and development is going well. Many think that compiling
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
time. Opal does have a small overhead, but not too much - and the gains are huge.

Opal does lack math abilities due to its customized use of operators; however, at anytime
with a backtick (\`) lets you inline vanilla JS.

On top of Opal for the frontend, volt also gives you Collections. They are:
- Page
- Params
- Store
- Local Store
- Cookies

Page is temporary memory.

Store is the DB/other user sync.

Params is the URL parameters. 

Local store and cookies are less important to consider right now. 

The normal MVC paradigm is not how Volt handles its design patterns. Volt follows what is popularly referred to as the MVVM pattern. This breaks down into three core concepts:

The model, which is as one may expect a simple object representing something in our application.

The view, which is the view and instances of data rendered to the client.

The view-model, which is functionally a controller of sorts. It starts with a view and any time a binding hits, a method is called to the controller, and it can respond.

At any point if the data changes (frontend or backend) the method will be called again and the data will be persisted.

Volt also does automatic code push, so any save results in an automatic reload of the server while developing. The component-centric system also allows for `Tags` to be carried into the new code utilizing the other components functionalities. 

A simple example of this would be this:

Lets say we have a simple to do list. 

If we create a buffer to hold data in the interim before we update a model, we now can change how we save. We declaratively state the save, and if it passes we can push the success. 

Now, if we add a component to the list, `volt-fields`, we can add in its functionality in the todo list's submission via `volt-fields`'s tag, and now we get free validations with success/error feedback in real time just by binding this tag and having it set through the model using a buffer.

Tasks are another wonderful piece of Volt. It allows you to call serverside code in an RPC fashion so that a promise is returned sharing error/success messages and data returned. This allows asynchronous work very simple.

By having one language, one router, central state, component extension, and automatic reactivity, Volt provides something in a simple package that is hard to find a real competitor for. 

So let's dig in.

[Getting Started](part_2.md)


