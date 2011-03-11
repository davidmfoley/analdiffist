class SmellyFile
  def self.class_variable
    @@class_variable = 42
  end

  def duplication
    if some_method
      some_method
    end

    some_method
  end

  def some_method
  end
end
