def raise_error_on(method_name)
  method_names = self.methods + self.private_methods

  unless method_names.include?(method_name.to_s)
    instance_eval(<<-HERE, __FILE__, __LINE__)
      def #{method_name}
        raise NotImplementedError, "You will need to define the method #{method_name}"
      end
    HERE
  end
end
