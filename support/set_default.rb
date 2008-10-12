
def raise_error_on(method_name)
  unless methods.include?(method_name.to_s)
    define_method(method_name) do
      raise NotImplementedError, "You will need to define the method #{method_name}"
    end
  end
end
