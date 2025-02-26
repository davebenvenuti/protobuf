#!/usr/bin/ruby

require 'google/protobuf'
require_relative 'message_pb'

def build_message
  BenchMessage.new(field_1: 123, field_2: "howdy")
end

1_000_000.times do
  build_message
end
