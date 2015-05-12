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

Now let us add a link to todos in our nav in `/views/main/main.html`, the skeleton of our
frontend:

```HTML
<:nav href="/todos">Todo List</:nav>
```
on `line 10`

Now, the application has this route established as a way to traverse the page on the
frontend, but we need to work on the backend to support this as well. Let us open up
`app/main/config/routes.rb` and add the line:

```RUBY
client '/todos', action: 'todos'
```

now in `app/main/views/main/todos.html` we can set up a simple form. In volt, frontend actions
are largely handled by actions beginning with `e-`. In this case, we will be taking advantage
of `e-submit`.

```RUBY
...
  <form e-submit='add_todo' role='form'>
    <div class='form-group'>
      <label>Task To Do</label> <input class='form-control' type='text' value='{{ page._new_todo }}'/> </div>
  </form>
...
```

Now, we have invoked a method called `new_todo`, and it is accessed by convention in Volt using `_`.
Our next step is to add this method to the controller. Open up `/app/main/controllers/main_controller.rb`.

```RUBY
...
    def add_todo
      page._todos << { name: page._new_todo }
      page._new_todo = ''
    end
...
```
Now, we should be seeing this empty list when we load the server up.

![Empty](http://i.imgur.com/FicHPjT.png)

So as you can see here, with our `e-submit` we use the method `add_todo` which invoked the value we assigned
to a volt model implicitely with `page._new_todo`. 

Now if we go back to our `todos.html` file we can iterate through all these todos quite simply.

```RUBY
...
{{ page._todos.each do |todo| }}
  <h4>{{ todo._name }}</h4>
{{ end }}
...
```

Now, this is quite trivial as we are not truly storing the data. To get this todo list to be persistent, we have to
tie in MongoDB, our default database in Volt.

To do this, we start with some frontend changes:

```RUBY
...
  <h4><input type='checkbox' checked='{{ todo._completed}}'/>
    {{todo._name }}
  <button e-click='todo.destroy'>X</button></h4>
...
```

This is what we should be seeing now.

![Populated with destroy and checkboxes](http://i.imgur.com/yJu3Q8l.png)

Now, so far we have been essentially going through the tutorial in the documentation. We have one more addition
involving this, and we will then proceed to go on and create a dashboard for various social media sites. First though,
we should style this up a bit and allow us to mark a todo completed. We can put this in `app/main/assets/css/app.css.scss`

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

With this, we can bind a class to our HTML in the frontend based off some logic. I am showing the
entirety of `todos.html` because it has also been restructured into a table with these new changes.

```RUBY
<:Body>
  <h1>Todo List</h1>

  <form e-submit="add_todo" role="form">
    <div class="form-group">
      <label>Todo</label>
      <input class="form-control" type="text" value="{{ page._new_todo }}" />
    </div>
  </form>

  <table class="todo-table">
    {{ page._todos.each do |todo| }}
      <tr>
        <td><input type="checkbox" checked="{{ todo._completed }}" /></td>
        <td class="{{ if todo._completed }}complete{{ end }}">{{ todo._name }}</td>
        <td><button e-click="todo.destroy">X</button></td>
      </tr>
    {{ end }}
  </table>

```

With this, we now get a lovely strikethrough on our todos. Next, it will be time to actually persist
them!

![todos with style](http://i.imgur.com/YBccwV5.png)

To begin persisting our todos, our first step is quite simple. We just need to hop back into `main_controller.rb`

```RUBY
class MainController < Volt::ModelController
  model :store
  ...
end
```

once we do this, instead of using `page._todos` we can just access `_todos`. 
[Next Chapter](/aside_1.md)

