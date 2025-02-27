#!/usr/bin/ruby

require 'google/protobuf'
require 'benchmark/ips'
require_relative 'message_pb'

module Kwargs
  BenchMessage = ::BenchMessage.clone

  class BenchMessage
    def initialize(**kwargs)
      init_arena

      kwargs.each_pair { |key, val| init_kwarg(key, val) }
    end
  end
end

module InitKwarg
  BenchMessage = ::BenchMessage.clone

  class BenchMessage
    def initialize(field_1:, field_2:)
      init_arena

      init_kwarg("field_1", field_1)
      init_kwarg("field_2", field_2)
    end
  end
end

module UseSetters
  BenchMessage = ::BenchMessage.clone

  class BenchMessage
    def initialize(field_1:, field_2:)
      init_arena

      self.field_1 = field_1
      self.field_2 = field_2
    end
  end
end

module Positional
  BenchMessage = ::BenchMessage.clone

  class BenchMessage
    def initialize(field_1, field_2)
      init_arena

      init_kwarg("field_1", field_1)
      init_kwarg("field_2", field_2)
    end
  end
end


field_1 = 123
field_2 = "howdy"

rubber_duck_msgs = [
  Kwargs::BenchMessage.new(field_1:, field_2:),
  InitKwarg::BenchMessage.new(field_1:, field_2:),
  UseSetters::BenchMessage.new(field_1:, field_2:),
  Positional::BenchMessage.new(field_1, field_2)
]

rubber_duck_msgs.each_with_index do |rubber_duck_msg, i|
  raise "[#{i}] field_1 mismatch: #{rubber_duck_msg.field_1}" unless rubber_duck_msg.field_1 == field_1
  raise "[#{i}] field_2 mismatch: #{rubber_duck_msg.field_2}" unless rubber_duck_msg.field_2 == field_2
end

Benchmark.ips do |x|
  x.report("initialize kwargs.each_pair") { Kwargs::BenchMessage.new(field_1:, field_2:) }
  x.report("initialize init_kwarg") { InitKwarg::BenchMessage.new(field_1:, field_2:) }
  x.report("initialize use setters") { UseSetters::BenchMessage.new(field_1:, field_2:) }
  x.report("initialize positional") { Positional::BenchMessage.new(field_1, field_2) }
end
