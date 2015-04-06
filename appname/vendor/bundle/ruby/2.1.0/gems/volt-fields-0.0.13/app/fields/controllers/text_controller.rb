module Fields
  class TextController < Volt::ModelController
    def index
      # Default to text fields
      if attrs.respond_to?(:type)
        @type = attrs.type
      else
        @type = 'text'
      end

      # Get the name of the field by looking at the method scope
      @field_name = attrs.value_last_method.gsub(/^[_]/, '')
    end

    # Find the parent reactive value that produced the value
    # (usually just model._field)
    def model
      attrs.value_parent
    end

    def label
      return attrs.label || @field_name.titleize
    end

    # Find the errors for this field
    def errors
      model.marked_errors[@field_name]
    end

    # When a field goes out of focus, then we want to start checking a field
    def blur
      attrs.value_parent.mark_field!(@field_name)
    end

    def marked
      model.marked_fields[@field_name]
    end
  end
end
