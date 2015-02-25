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

## Persisting Todos
Now, for a true to do list we need to be able to remove it as well.

```RUBY
def remove_todo(todo)
  page._todos.delete(todo)
end
```
`line 16`

and we need a button to complete them, so back to `app/main/views/main/todos.html`

```HTML
...
<tr>
  <td><input type="checkbox" checked="{{ todo._completed }}" /></td>
  <td class= "{{ if todo._completed }}complete{{ end }}>{{ todo._name }}</td>
  <td><button e-click="remove_todo(todo)">X</button></td>
</tr>
...
```
`line 18, inside the each loop`

and lastly some CSS to help display things:

```CSS
textarea {
  height: 140px;
  width: 100%;
}

.todo-table {
  width: auto;

  tr {
    &.selected td {
    background-color: #428bca;
    color: #FFFFFF;

    button {
    color: #000000;
    }
  }

  td {
    padding: 5px;
    border-top: 1px solid #EEEEEE;

    &.complete {
      text-decoration: line-through;
      color: #CCCCCC;
      }
    }
  }
}
```
`app/main/assets/css/app.css.scss`

Now if we go to our page, we will be pleased to see the ability to check
and remove lists is working perfectly. However, we have more work to do for
a completely functional list. 
#### to be continued...

