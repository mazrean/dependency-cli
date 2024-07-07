# frozen_string_literal: true

require "thor"
require_relative "depslist/version"
require "dependabot/gradle"
require "dependabot"

module Depslist
  class Error < StandardError; end

  class Cli < Thor
    desc "version", "Print version"
    def version
      puts Depslist::VERSION
    end

    desc "list", "List dependencies"
    def list(path="./build.gradle")
      file = Dependabot::DependencyFile.new(name: "build.gradle", directory: File.dirname(path), content:File.read(path))
      parser = Dependabot::Gradle::FileParser.new(dependency_files: [file], source: nil)
      dependencies = parser.parse

      dependency_list = []
      dependencies.each do |dep|
        parts = dep.name.split(':')
        dependency_list.push({
                               'groupId' => parts[0],
                               'artifactId' => parts[1],
                               'version' => dep.version
                             })
      end
      puts dependency_list.to_json
    end
  end
end
