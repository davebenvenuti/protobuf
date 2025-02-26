#!/usr/bin/ruby

require 'google/protobuf'
require 'benchmark/ips'
require_relative 'message_pb'

def build_message
  BenchMessage.new(field_1: 123, field_2: "howdy")
end

rubber_duck_msg = build_message

raise "field_1 mismatch: #{rubber_duck_msg.field_1}" unless rubber_duck_msg.field_1 == 123
raise "field_2 mismatch: #{rubber_duck_msg.field_2}" unless rubber_duck_msg.field_2 == "howdy"


Benchmark.ips do |x|
  x.report("initialize") { build_message }
end

# 1_000_000.times do
#   build_message
# end
