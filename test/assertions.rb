module Minitest::Assertions
  def assert_instance_method_call_count(count, klass, method, &blk)
    actual_count = instance_method_call_count(count, klass, method, &blk)
    assert actual_count == count,
      "Expected #{count} calls to method #{method} on klass #{klass} but registered #{actual_count}"
  end

  private

  def instance_method_call_count(count, klass, method)
    registered_counts = 0
    klass.class_exec do
      alias_method "old_#{method}", method
      define_method(method) do |*args|
        registered_counts += 1
        send("old_#{method}", *args)
      end
    end
    yield
    registered_counts
  end
end
