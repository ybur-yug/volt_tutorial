## Your First App
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
<:nav href="/todos">Todo List</:nav>
```
on `line 10`

Now, the application has this route established as a way to traverse the page on the
frontend, but we need to work on the backend to support this as well. Let us open up
`app/main/config/routes.rb` and add the line:

TODO 

[Next Chapter](/aside_1.md)

