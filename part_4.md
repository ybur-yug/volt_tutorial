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
find that we can log out a user with `Volt.logout`. It also appears that `volt-fields` is in the 
mix here. Let's see what this does, and if we can use it with anything we have.

### Using Other Components
in progress...
