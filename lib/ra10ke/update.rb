# frozen_string_literal: true

require 'git'
require 'r10k/puppetfile'

module Ra10ke
  module Update
    class Task
      attr_reader :repo, :puppetfile

      def initialize
        @repo = Git.open('.')
        @original_branch = repo.current_branch
        @puppetfile = get_puppetfile
        @puppetfile.load!
      end

      def run()
        modules = Ra10ke::Dependencies::Verification.new(@puppetfile).processed_modules
        modules.each do |mod|
          next if mod[:version] == 'latest'

          # Check if the module is ignored
          next if Ra10ke::Dependencies::Verification.new(@puppetfile).ignored_modules.include?(mod[:name])

          # Update the module version to 'latest'
          mod[:version] = 'latest'
        end
      end

      def validate_clean_repo
        return if repo.status.changed.empty? && repo.status.untracked.empty?

        abort('Git repository is not clean. Please commit or stash your changes before running this task.')
      end

      def get_puppetfile
        R10K::Puppetfile.new(Dir.pwd)
      end
    end

    def define_task_update(*_args)
      desc 'Check for module updates in a Puppetfile and update the module versions'
      task :update do |_task, _args|
        Task.new.run()
      end
    end
  end
end
