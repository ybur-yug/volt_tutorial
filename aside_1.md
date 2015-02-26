## Aside 1: Frontend Ruby Play

As noted prior, it is quite simple to play with Ruby code on the frontend. Let's
hop over to our todos page and try playing with it a bit.

`editor app/main/views/main/todos.html`

Now, let's just add some code to the bottom:

```
<h1>{{ a  = 1 }}</h1>
<h2>{{ b  = 2 }}</h2>
<h3>{{ c  = 3 }}</h3>
```

Now, when the page reloads we will see a 1, 2, and 3 getting smaller. Let's try
playing with the todos we have in the loop. If we were to add the line:

`<td>{{ puts todo._name }}</td>`

`line 17` 

We can now open up the JavaScript console, and easily see each todo's name
logged. Obviously, with the ability to store variable and play with logic
you now have the full power of Ruby on your frontend. 

Overall this aside is just to help illustrate that we *truly* can write Ruby
everywhere with Volt. And it sure is nice.

Discard these changes after you are done playing, and move on to 

[Your First App](/part_3.md)
