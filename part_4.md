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

## Adding Due Dates

## Model Relations

## Validations

## Adding A Component - volt-fields

## Adding Multiple Lists

## Package it as a component
