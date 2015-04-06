require 'spec_helper'

describe Todo do

  todo = Todo.new(name: "Breakfast")
  $page.store._todos << todo 

  it "should save the todo" do
    expect(todo._name).to eq 'Breakfast'
  end
end
