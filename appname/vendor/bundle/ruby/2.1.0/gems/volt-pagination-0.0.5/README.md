# Volt::Pagination

Provides a pagination component to easily show the paging.

## Usage

Add this line to your application's Gemfile:

    gem 'volt-pagination'

And then execute:

    $ bundle

Then include it as a component in your main component's ```dependencies.rb```

    component "pagination"

To page a collection or query, simply use ```.skip``` and ```.limit```
Assuming a page size of 10:

    def items_on_page
      store._items.find({active: true}).skip((params._page.or(1).to_i - 1) * 10).limit(10)
    end

Then in your view you can add:

```html
<:pagination total="{{ store._items.size }}" per_page="10" />
```

```per_page``` defaults to 10 and ```page``` defaults to params._page

The pagination tag supports the following options:

- total (required): the total number of items.
- per_page (default: 10): how many items per page.
- page-param-name (default: ```page```): the name of the page attribute stored in params  (starting with 1)
- window (default: 5): the number of pages to show around the current page
- outer_window: (default: 1): the number of pages to show at the start and end of the pager.
