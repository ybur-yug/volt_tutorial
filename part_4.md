## Getting Real
We now have a functional application skeleton. We are going to take this, and instead of extending
the worlds ability to make todos, lets restructure this and learn a little more about internal
logic. In order to do this, lets first make the landing page of our application the todos page.

```RUBY
# get '/', {}
get '/', _action: 'links'
```
`bottom line`

Feel free to delete the old one, rather than just comment it. This will force our routes to now
make the root url our list of 'links'. Now, to change up our 'todos' to behave like 'links'.


