# frozen_string_literal: true

require 'test_helper'

class DynamicModulesTest < TestBase
  def find_anonymous_modules(object)
    object.ancestors.select { |m| m.to_s[/^#<Module/] }
  end

  def test_inheritance
    klass = Class.new do
      include Wardrobe
      attribute :foo, String
    end

    klass_mods = find_anonymous_modules(klass)
    assert_equal 1, klass_mods.length
    assert_equal [:foo, :foo=], klass_mods.first.instance_methods
    refute klass_mods.first.frozen?

    child_klass = Class.new(klass) do
      attribute :bar, String
    end

    # Since the wardrobe config on klass has merged the module should now be frozen.
    assert klass_mods.first.frozen?
    child_klass_mods = find_anonymous_modules(child_klass)
    assert_equal 2, child_klass_mods.length
    assert_equal [:foo, :foo=], child_klass_mods.last.instance_methods
    assert_equal [:bar, :bar=], child_klass_mods.first.instance_methods
    assert child_klass_mods.last.frozen?
    refute child_klass_mods.first.frozen?


    # Lets open up child_klass and add a few more attributes

    child_klass.class_exec do
      attribute :one, String
      attribute :two, String
    end

    assert_equal [:one, :two, :bar, :bar=, :one=, :two=].to_set, child_klass_mods.first.instance_methods.to_set
    refute child_klass_mods.first.frozen?
    assert_equal 2,find_anonymous_modules(child_klass).length
  end

  def test_module_includes
    mod_1 = Module.new do
      include Wardrobe
      attribute :mod_1, String
      instance_methods_module do
        define_method(:_test_) do
          'instance mod_1'
        end
      end
      class_methods_module do
        define_method(:_test_) do
          'class mod_1'
        end
      end
    end
    refute mod_1.wardrobe_config.class_methods_module.frozen?
    refute mod_1.wardrobe_config.instance_methods_module.frozen?

    mod_2 = Module.new do
      include Wardrobe
      attribute :mod_2, String
      instance_methods_module do
        define_method(:_test_) do
          'instance mod_2'
        end
      end
      class_methods_module do
        define_method(:_test_) do
          'class mod_2'
        end
      end
    end
    refute mod_2.wardrobe_config.class_methods_module.frozen?
    refute mod_2.wardrobe_config.instance_methods_module.frozen?

    mod_combined = Module.new do
      include mod_1
      include mod_2
    end

    assert mod_1.wardrobe_config.class_methods_module.frozen?
    assert mod_1.wardrobe_config.instance_methods_module.frozen?
    assert mod_2.wardrobe_config.class_methods_module.frozen?
    assert mod_2.wardrobe_config.instance_methods_module.frozen?
    assert mod_combined.wardrobe_config.class_methods_module.frozen?
    assert mod_combined.wardrobe_config.instance_methods_module.frozen?

    mod_combined.module_exec do
      instance_methods_module do
        define_method(:_comb_) do
          'instance comb'
        end
      end
      class_methods_module do
        define_method(:_comb_) do
          'class comb'
        end
      end
    end

    refute mod_combined.wardrobe_config.class_methods_module.frozen?
    refute mod_combined.wardrobe_config.instance_methods_module.frozen?

    klass = Class.new do
      include mod_combined
    end

    assert mod_combined.wardrobe_config.class_methods_module.frozen?
    assert mod_combined.wardrobe_config.instance_methods_module.frozen?
    assert klass.wardrobe_config.class_methods_module.frozen?
    assert klass.wardrobe_config.instance_methods_module.frozen?
    assert_equal 'instance mod_2', klass.new._test_
    assert_equal 'class mod_2', klass._test_
  end

  def test_nested_classes_instance_methods
    one = Class.new do
      include Wardrobe
      attribute :one, String
      instance_methods_module do
        define_method(:_one_) { 'one' }
        define_method(:order) { '1' }
      end
    end

    two = Class.new(one) do
      attribute :two, String
      instance_methods_module do
        define_method(:_two_) { 'two' }
        define_method(:order) { '2' }
      end
    end

    three = Class.new(two) do
      attribute :three, String
      instance_methods_module do
        define_method(:_three_) { 'three' }
        define_method(:order) { '3' }
      end
    end

    instance = three.new
    assert instance.respond_to?(:one)
    assert instance.respond_to?(:two)
    assert instance.respond_to?(:three)
    assert instance.respond_to?(:order)
    assert_equal 'one', instance._one_
    assert_equal 'two', instance._two_
    assert_equal 'three', instance._three_
    assert_equal '3', instance.order
  end

  def test_nested_modules_instance_methods
    one = Module.new do
      include Wardrobe
      attribute :one, String
      instance_methods_module do
        define_method(:_one_) { 'one' }
        define_method(:order) { '1' }
      end
    end

    two = Module.new do
      include one
      attribute :two, String
      instance_methods_module do
        define_method(:_two_) { 'two' }
        define_method(:order) { '2' }
      end
    end

    three = Module.new do
      include two
      attribute :three, String
      instance_methods_module do
        define_method(:_three_) { 'three' }
        define_method(:order) { '3' }
      end
    end

    klass = Class.new do
      include three
    end

    instance = klass.new
    assert instance.respond_to?(:one)
    assert instance.respond_to?(:two)
    assert instance.respond_to?(:three)
    assert instance.respond_to?(:order)
    assert_equal 'one', instance._one_
    assert_equal 'two', instance._two_
    assert_equal 'three', instance._three_
    assert_equal '3', instance.order
  end

  def test_nested_modules_class_methods
    one = Module.new do
      include Wardrobe
      class_methods_module do
        define_method(:one) { 'one' }
        define_method(:order) { '1' }
      end
    end

    two = Module.new do
      include one
      class_methods_module do
        define_method(:two) { 'two' }
        define_method(:order) { '2' }
      end
    end

    three = Module.new do
      include two
      class_methods_module do
        define_method(:three) { 'three' }
        define_method(:order) { '3' }
      end
    end

    klass = Class.new do
      include three
    end


    assert_equal 'one', klass.one
    assert_equal 'two', klass.two
    assert_equal 'three', klass.three
    assert_equal '3', klass.order
    
    klass_two = Class.new do
      include two
    end
    assert_equal '2', klass_two.order
  end

  def test_nested_classes_class_methods
    one = Class.new do
      include Wardrobe
      class_methods_module do
        define_method(:one) { 'one' }
        define_method(:order) { '1' }
      end
    end

    two = Class.new(one) do
      class_methods_module do
        define_method(:two) { 'two' }
        define_method(:order) { '2' }
      end
    end

    three = Class.new(two) do
      class_methods_module do
        define_method(:three) { 'three' }
        define_method(:order) { '3' }
      end
    end

    assert_equal 'one', three.one
    assert_equal 'two', three.two
    assert_equal 'three', three.three
    assert_equal '3', three.order
  end
end
