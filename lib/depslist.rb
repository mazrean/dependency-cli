# frozen_string_literal: true

require "thor"
require_relative "depslist/version"

module Depslist
  class Error < StandardError; end

  class Cli < Thor
    desc "version", "Print version"
    def version
      puts Depslist::VERSION
    end

    desc "list", "List dependencies"
    def list
      puts "Hello, world!"
    end
  end
end
