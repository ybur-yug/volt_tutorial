class MainController < Volt::ModelController
  model :page

  def index
  end

  def about
  end

  def todos
    self.model = :store
  end

  def start_offset
    params._page.or(1).to_i * per_page
  end

  def per_page
    5
  end

  def paged_todos
    store._todos.skip(start_offset).limit(per_page) 
  end

  def add_todo
    self._todos << { name: _new_todo }
    _new_todo = ''
  end

  def remove_todo(todo)
    self._todos.delete(todo)
  end

  def completed
    self._todos.count { |v| v._complete.true? }
  end
  
  def percent_complete
    (completed / _todos.count.to_f * 100).round 
  end
  private
  
  # The main template contains a #template binding that shows another
  # template.  This is the path to that template.  It may change based
  # on the params._controller and params._action values.
  def main_path
    params._controller.or('main') + '/' + params._action.or('index')
  end

  # Determine if the current nav component is the active one by looking
  # at the first part of the url against the href attribute.
  def active_tab?
    url.path.split('/')[1] == attrs.href.split('/')[1]
  end
end
