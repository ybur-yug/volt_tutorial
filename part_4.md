## Adding Due Dates

## Model Relations

## Validations

## Adding A Component - volt-field

## Progress Bar

## Package it as a component



# WIP FROM HERE ON
## Getting Real

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


So, we can simply add todos, subtract todos, and delete them. This is fine and dandy but its not a
'real' application. So let's start with something interesting. Let's start playing with users.

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
