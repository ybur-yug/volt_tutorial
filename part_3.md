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

`get '/todos', _action: 'todos'`
`line 8`

This will allow the server to recognize this path. If we check out the current page,
we can now click our way through to the todo page. Next, we'll need a form to submit
them from the clientside. open up `app/main/views/main/todos.html` and we can add this
block below our `h1` tags:

```HTML
    <body>
      <form e-submit="add_todo" role="form">
        <div class='form-group'>
          <label>Todo</label>
          <input class="form-control" type="text" value="{{ page._new_todo }}">
        </div>
      </form>
    </body>
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
        <table class="todo-table">
          {{ page._todos.each do |todo| }}
          <tr>
            <td>{{ todo._name }}</td>
          </tr>
          {{ end }}
        </table>
```
`line 13`

#### [commit 497be29e29eac302d903d5326fbb0e83163be9fc](http://www.github.com/rhgraysonii/volt_tutorial/commit/497be29e29eac302d903d5326fbb0e83163be9fc)

## Actual Todo Functionality 
Now, for a true to do list we need to be able to remove it as well.

```RUBY
def remove_todo(todo)
  page._todos.delete(todo)
end
```
`line 16`

This simple accesses the `_todos` stored in our given collection `page` and deletes it from the
list. These are now saved anywhere permanently, yet. But this will be remedied soon.

If we move on to the frontend, we need a button to complete them, so

`editor app/main/views/main/todos.html`

```HTML
        <table class="todo-table">
          {{ page._todos.each do |todo| }}
          <tr>
            <td>
              <h5>{{ todo._name }}
              <button e-click="remove_todo(todo)">x</button></h5>
            </td>
          </tr>
          {{ end }}
        </table>
```
`lines 13-24`

Now, we should be able to knock these todos off the list and know what we have completed. But
we still need a way to access them through the store, rather than losing them every page reload.
In order to do this inside our `main_controller.rb` we simple add the line

```RUBY
model :store
```

Inside the class, and then replace all instange of `page.` with `''`. If we do the same thing in
the view, we will be good to go and have persisted todos!

[commit 773b4825ed70acf97d3b8a82e5b7bf57115ad89f](http://www.github.com/rhgraysonii/volt_tutorial/commit/773b4825ed70acf97d3b8a82e5b7bf57115ad89f)

Now, let's get a little more intense. Now we will start messing with users. This is one of the most
robust free features we get in Volt and offers quite a bit for us to toy with.

### Users in Volt
Volt is quite generous in that it provides us a default implementation that allows us to trivially
handle auth in the user flow process. Work is still being done on it, but no needs for worry there.
The main idea is its already good and will only get better. By default, the `_users` collection
will hold all registered Users. Test this by signing a few up manually, and then let us list them
on the homepage so we can see whose todos these all are.

```RUBY
...
      <div class='col-md-2'>
      {{ if Volt.user? }}
        {{ _users.each do |u| }}
          {{ u._name }}<br>
        {{ end }}
      {{ end }}
      </div>
...
```
`After first col <div> is closed inside body`

Now, you should see a list of users on the right of your page. Now, what if to make a todo you
had to be a user so that you were part of whoever was working on this list? And what if we 
could leave messages for each other? Well, that sounds awesome. Let's do it. But first lets inspect
this user class a little further and see what exactly the true possibilities are. 

There are several pieces to the user model provided to us for free by default. To begin, the core
of all of this is the `User` class. If we fire up the console

`bundle exec volt console`

Now, lets check out a user in the store.

`store._users.first`

```RUBY
=> <User:70114261092380 {:_id=>"ff8995c8ab30371f43b9f4ed", 
                         :email=>"bob@bob.com",
                         :hashed_password=>"$2a$10$QhfnyvBMObaOUfD38P/nkeH4Mk5DfnkVBa0ohhh5f0ZCJA5H.5T2a", 
                         :name=>"bobobob"}
```

Alright. So, we have a unique ID, an email, and a name. Wonderful. This allows us to do several
things for free: we can have users 'own' a model. We can give a model a `user_id` specification 
that will identify which user is related to this new model. We also should dig a little deeper
into the features rather than just the obvious. If we take a look at the core class, `User` in
Volt's source we can gather another tidbit.

```RUBY
...
    validate login_field, unique: true, length: 8
    validate :email, email: true
...

```
`user.rb, Volt source`

So we also get validations on our login. Checking the emails presence and length. Nice. We also
find that we can log out a user with `Volt.logout`. 

Let's continue adding some complexity to this application now that it is user-specific. This will
let us get beyond the simple out-of-the-box gimmes. As you saw earlier when first creating our
list, the `e-something` values are for events. 

[commit f596e1b9aa487f723e9c660afb837a276178e36](http://www.github.com/rhgraysonii/volt_tutorial/f596e1b9aa487f723e9c660afb837a276178e36)


# WIP AFTER HERE
CSS to help display things:

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
and remove lists is working perfectly. However, we are not persisting data!
Once we fix this, we may be able to call this todo app complete. 

`editor app/main/controllers/main_controller.rb`

Directly below the class declaration, we can add:

```
...
class MainController < Volt::ModelController
  model :store
...
```
`line 3`

Now, we can replace all references of page._todos, our current, non-persisted store,
and move to using MongoDB. If you have not installed Mongo before, you can find
installation guides [here](link). Once installed, start it as a background process:

`mongod`

From here, we should be automagically moving our todos to mongo. Let's create some
and try it out. Open several browser windows and start adding/checking/removing todos.
They will be perfectly up to date every single time!

Now that we've got the basics, lets build something nontrivial.

[Getting Real](/part_4.md)
