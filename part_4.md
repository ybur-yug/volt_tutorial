## Pagination
Since we might end up with quite a long list of todos, it would make sense for us to institute some sort of pagniation system
that will allow us to only display X amount, and query the rest. Volt makes this quite friendly. First things first, this will
be the first thing we need to add a `component` for. To do this, we open up our Gemfile

`editor Gemfile`

and we add the line

```RUBY
...
gem 'volt-pagination'
...
```

and then

`editor app/config/dependencies.rb`

```RUBY
...
component 'pagination'
...
```

Now that we have our scaffolding, lets open up our todos view and start preparing it for being paginated:

```RUBY
...
  def start_offset
    params._page.or(1).to_i * per_page # find the current page
  end

  def per_page
    10 # per page limit
  end

  def paged_todos
    store._todos.skip(start_offset).limit(per_page)
    # this gets us the current batch of todos from the cursor
  end
...
```

With these methods added, we are able to now go into our view, and with some simple changes we will be good to go:

```RUBY
...
paged_todos.each do |todo|
... # this replaces `_todos.each`
<:pagination total='{{ _todos.count }}'>
... # this goes right before the closing table tag

```

What we have doe here is call our controller method that handles the pagination math, and then we are simply passing it into
our helper that `volt-pagination` gives us. Check out your page, and once you have enough todos you will have pagination!

## Buffers
With the introduction of a buffer, we can handle errors on our todo and resolve them using the promise that is returned.
If we want to do this, we can switch a little bit up in our controller:

`editor app/main/controllers/main/main_controller.rb`

```RUBY
...
def add_todo
  new_todo = _todos.new.buffer
  new_todo._name: _new_todo
  new_todos.save!.then do
    flash._successes "Todo Saved"
  end.fail do |err|
    flash._errors "Todo Failed To save due to #{err}"
  end
  _new_todo = ''
end
...
```

This will now hold it in the interim, wait for the promise to resolve, and then proceed to give you the appropriate flash
message based upon the return value.

## Validations
Up to this point, we have exclusively operated within our controller and view in order to persist any sort of logic. While this
is easy, and it makes for an awesome and fast bootstrapping process, if we want to get nontrivial functionality it would be
best 
if we had something in which we could namespace our models and embed some of the logic there, rather than ending up with this
single massive controller called `MainController`. So, lets make a model:

`bundle exec volt generate model Todo`

Now, with this we see a file being created in our `app/main/models` directory. Inside here, we can open it up and see
it is quite simple by default

```RUBY
class Todo < Volt::Model
end

```

But, we now have a very explicit space we can declare logic and methods for our todos!

## Adding A Component - volt-fields

## Model Relations

## Adding Multiple Lists

## Extracting Todos

## Package it as a component
