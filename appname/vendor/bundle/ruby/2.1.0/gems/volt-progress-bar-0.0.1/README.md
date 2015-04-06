# Volt Progress Bar

This is a simple progress bar component for Volt.  The progress bar updates dynamically with a Volt reactive value.

# Install

Include the following code in your gemfile:

    gem 'volt-progress-bar'
    
Add the progress bar component to your config/dependencies.rb.

```ruby
  component 'bootstrap'
  component 'progress-bar'
```

The bootstrap component is not necessary, but does include styling for the progress bar out of the box.  If you wish to not use bootstrap, or you want to use your own styles, read the styling section below.

# Use

To get a progress bar, simply put this code in a Volt view.

    <:progress-bar value="{_width}" total="100" />
  
Value must be set to a reactive value and total can either be a reactive value or an integer.

# Styling

Override the progress and progress-bar classes to customize the progress bar's style.

```css
  .progress{
    width:100px;
  }
  .progress-bar{
    background:green;
  }
```
