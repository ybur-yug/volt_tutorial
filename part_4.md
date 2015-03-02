## Getting Real

So, we can simply add todos, subtract todos, and delete them. This is fine and dandy but its not a
'real' application. So let's start with something interesting. Let's start playing with users.

### Users in Volt
Volt is quite generous in that it provides us a default implementation that allows us to trivially
handle auth in the user flow process. Work is still being done on it, but no needs for worry there.
The main idea is its already good and will only get better. By default, the `_users` collection
will hold all registered Users. Test this by signing a few up manually, and then let us list them
on the homepage so we can see whose todos these all are.

```RUBY
...
  <div class='col-md-1'>
  {{ _users.each do |u| }}
    {{ u._name }}<br>
  {{ end }}
  </div>
...
```
`inside the row div, after the first col-md-4`

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

### Extending Capability With Models
We want to validate some things in our todos. And we can do that easily, but first we need some
abstraction to carry that through to the clientside. Enter models.

`volt generate model todo`

Now, we have a base model for our todos that is empty. How about to start we verify the description
is at least 4 characters. We can add

```RUBY
  validates :description, length: 10
```

inside the classs and it is as simple as that. We now will not accept a description with less than
4 characters. Now what if you couldn't see the todos unless you were a logged in user? This would
keep them private so only users of our app can see them, and share the list. In order to accomplish
this we add a very simple wrapping to the html of our page. Around the todos block, we can add this

```RUBY
{{ if Volt.user? }}
[todo block]
{{ end }}
```

Let's continue adding some complexity to this application now that it is user-specific. This will
let us get beyond the simple out-of-the-box gimmes. As you saw earlier when first creating our
list, the `e-something` values are for events. Let's add an event that will allow us to take
advantage of another built in collection, `params`.

If we reference the documentation, this is what we are told of the params collection:

```MARKUP
params  values will be stored in the params and URL. Routes can be setup to change how params are
shown in the URL. (See routes for more info)
```

Okay, awesome. So we can very easily mess with parameters and dont have to worry about query
strings or anything. Let's start by keeping a current index on which todo is selected in the app.  

Now, only logged in users can see our todos, and they are doing some basic validation. But lets
get some more robust validation going on the client side. If you noticed, you get live feedback
in the fields for user sign up, but not with our todo. To add this, we will need to add a 
dependency, `volt-fields`. This is what we will go into next. Remove the annotations for this code
to properly be useable.


```RUBY
...
      <table class="table todo-table">
        {{ _todos.each do |todo| }}
          <tr
            class="{{ if params._index.or(0).to_i == index }}selected{{ end }}" # we check if the params index is equal to itself or 0
            e-click="params._index = index"> # upon clicking we make an event setting the index to this var
            <td><input type="checkbox" checked="{{ todo._complete }}" /></td>
            <td class="{{ if todo._complete }}complete{{ end }}">{{ todo._label }}</td>
            <td><button e-click="self._todos.delete_at(index)">X</button></td> # We delete based off this new index id
          </tr>
        {{ end }}
      </table>
...
```

With these changes, we can now have the currently selected parameter highlighted easily with the
css we added earlier. But first we have to make the controller play nice before we can render this. Open back up `editor app/main/controllers/main/main_controller.rb` again.

```RUBY
...
  def current_todo
    _todos[params._index.or(0).to_i]
  end
...
```

Adding this method will allow us to easily correspond with the logic added above to add the class.
Now, we need to note the change in method use for the deletion. We are using `delete_at`, which is
a Volt specific operator for working with models in our store. To illustrate this, once
we go into the new list we can easily begin selecting todos and the index of the selected parameter
will automatically show and change in the url as it moves and is altered. 

Next, why not allow ourselves the ability to annotate this todo with a simple note? This is quite
simple. `editor app/main/views/main/todos.html`.

```RUBY
...
      {{ if current_todo }}
        <h2>{{ current_todo._label }}</h2>
        <textarea>{{ current_todo._description }}</textarea>
      {{ end }}
...
```

This simple throws the label of the currently selected todo above a box, and allows us to add a note
to it with our `description` value. 
