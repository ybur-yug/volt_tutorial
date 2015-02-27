## Getting Real

So, we can simply add todos, subtract todos, and delete them. This is fine and dandy but its not a
'real' application. So let's start with something interesting. Let's start playing with users.

## Users in Volt
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
could leave messages for each other? Well, that sounds awesome. Let's do it
