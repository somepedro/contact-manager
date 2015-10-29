#!/usr/bin/env ruby

class Contact

  attr_accessor :first_name, :last_name, :email, :phone

  # Initialize contact from hash
  def initialize(args = {})
    args.each do |key,value|
      instance_variable_set("@#{key}", value) unless value.nil?
    end
  end
  
end
