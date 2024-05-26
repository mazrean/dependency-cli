# frozen_string_literal: true

module Depslist
  class Analyzer
    def initialize
      @dependencies = []
    end

    def analyze
      Gem.loaded_specs.each do |name, spec|
        @dependencies << { name: name, version: spec.version.to_s }
      end
    end

    def to_s
      @dependencies.map { |dep| "#{dep[:name]} (#{dep[:version]})" }.join("\n")
    end
  end
end
