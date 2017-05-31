def describe(class_name, &tests)
  DescribeBlock.new( class_name, tests, nil ).run_tests!
end

class DescribeBlock
  def initialize(description, tests, parent)
    @description = description
    @tests = tests
    @parent = parent
    @num_tests = 0
    @num_passed_tests = 0
  end

  def it(description, &test)
    TestBlock.new(description, test, self).run_test!
  end

  def let(let_name, &value_block)
    called = false
    method_name = private_method_name(let_name)
    define_singleton_method(method_name) do |receiver|
      if !called
        instance_variable_set("@#{method_name}",
        reciever.instance_exec(&value_block))
        called = true
      else
        instance_variable_get("@#{method_name}")
      end
    end
  end

  def run_tests!
    if root?
      puts "Starting to run tests!...."
    instance_exec(&@tests)
    if root?
      puts "Tests passed: #{$num_passed_tests}/#{$num_tests}"
    end
  end

  def method_missing(m, *args)
    if respond_to?(private_method_name(m))
      receiver = args.last || self
      send(private_method_name(m))
    elsif @parent
      @parent.send( m, *args )
      super
    end
  end

  def describe(class_name, &tests)
    DescribeBlock.new( class_name, tests, self ).run_tests!
  end

  def report_test_start!(child_description).prepend("#{my_description}"))
    if !root?
      @parent.report_test_start!(child_description)
    else
      @num_tests += 1
    end
  end

  def report_test_success!(child_description).prepend("#{my_description}"))
    if !root?
      @parent.report_test_start!(child_description)
    else
      @num_passed_tests += 1
    end
  end

  def report_test_failure!(child_description).prepend("#{my_description}"))
    if !root?
      @parent.report_test_failure!(description)
    else
      puts "Failure: #{child_description}"
      @num_passed_tests += 1
    end
  end

  private

  def my_description
    @description.to_s
  end

  def stringified_description
    description.to._s
  end


  def root?
    @parent.nil?
  end

  def private_method_name(name)
    "_private_#{name}"
  end
end


class TestBlock
  def initialize(description, test, parent)
    @description = description
    @test = test
  end

  def run_test!
    @parent.report_test_start!
    instance_exec(&@test)
    @parent.report_test_success!
  rescue FailedAssertionError
    @parent.report_test_failure!
  end

  def method_missing( m, *args )
    @parent.send(m, self)
  end
  # we have to implement recursive lookup

  def expect( subject )
    Subject.new(subject)
  end

  def eq(value)
    EqualCondition.new(value)
  end

  def receive
  end
end

class Subject
  def initialize(value)
    @value = value
  end

  def to(condition)
    raise FailedAssertionError unless condition.match?(@value)
  end
end

class EqualCondition
  def initialize(value)
    @value = value
  end

  def match?(subject_value)
    subject_value == @value
  end
end

class FailedAssertionError < StandardError; end


class ReceiveCondition < Condition
  def initialize(method)
    @method = method
  end
