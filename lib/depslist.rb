# typed: strong
# frozen_string_literal: true

require "thor"
require_relative "depslist/version"
require "dependabot/gradle"
require "dependabot"
require 'jimson'

module Depslist
  class Error < StandardError; end
  class Cli  < Thor
    desc "version", "Print version"
    def version
      puts Depslist::VERSION
    end

    desc "list", "List dependencies"
    def list(path="./build.gradle")
      dependency_list = []
      analyze(path).each do |dep|
        parts = dep.name.split(':')
        dependency_list.push({
                               'groupId' => parts[0],
                               'artifactId' => parts[1],
                               'version' => dep.version
                             })
      end
      puts dependency_list.to_json
    end

    desc "server", "Start server"
    def server

      server = Jimson::Server.new(Handler.new)

      loop do
        input = $stdin.gets
        break if input.nil? || input.strip.empty?

        response = server.handle_request(JSON.parse(input))
        if response.nil?
          response = server.error_response("Invalid request", input)
        end
        puts response.to_json
        STDOUT.flush
      end
    end

    private
    class Handler < Cli
      extend Jimson::Handler
      def list(path)
        dependency_list = []
        analyze(path).each do |dep|
          parts = dep.name.split(':')
          dependency_list.push({
                                 'groupId' => parts[0],
                                 'artifactId' => parts[1],
                                 'version' => dep.version
                               })
        end
        dependency_list
      end
    end

    protected
    desc "analyze", "Analyze dependencies"
    def analyze(path)
      file = Dependabot::DependencyFile.new(name: "build.gradle", directory: File.dirname(path), content:File.read(path))
      parser = Dependabot::Gradle::FileParser.new(dependency_files: [file], source: nil)
      parser.parse
    end
  end
end
