require File.join(File.dirname(__FILE__), 'helper')
require 'fileutils'
require 'find'

module Dotfiles
  class ConfigFileTest < ::Test::Unit::TestCase

    def setup
      Dotfiles.debug = false
      setup_fixtures
    end

    def test_install_should_symlink_dot_rc_files
      config = ConfigFile.new File.join(fixture_project_dir, 'dot_thisrc'),
        :project_dir => fixture_project_dir,
        :home_dir => fixture_home_dir

      config.install fixture_home_dir
      assert_symlink File.join(fixture_home_dir, '.thisrc'), File.join(fixture_project_dir, 'dot_thisrc')
    end

    def test_install_should_create_directories_before_linking_deep_files
      config = ConfigFile.new File.join(@fixture_project_dir, 'dot_this', 'settings'),
        :project_dir => fixture_project_dir,
        :home_dir => fixture_home_dir

      config.install fixture_home_dir
      assert_symlink File.join(fixture_home_dir, '.this', 'settings'), File.join(fixture_project_dir, 'dot_this', 'settings')
    end

    def test_install_should_raise_if_file_already_exists
      config = ConfigFile.new "#{fixture_project_dir}/dot_this/settings",
        :project_dir => fixture_project_dir,
        :home_dir => fixture_home_dir
      install_file = "#{fixture_home_dir}/.this/settings"
      FileUtils.mkdir_p File.dirname("#{fixture_home_dir}/.this/settings")
      FileUtils.touch "#{fixture_home_dir}/.this/settings"

      assert_raises(RuntimeError) { config.install fixture_home_dir }
    end

    def test_install_should_replace_existing_file_if_force_option_is_set
      previous_force_value = Dotfiles.force
      Dotfiles.force = true

      config = ConfigFile.new "#{fixture_project_dir}/dot_this/settings",
        :project_dir => fixture_project_dir,
        :home_dir => fixture_home_dir
      install_file = "#{fixture_home_dir}/.this/settings"
      FileUtils.mkdir_p File.dirname("#{fixture_home_dir}/.this/settings")
      FileUtils.touch "#{fixture_home_dir}/.this/settings"

      assert_nothing_raised { config.install fixture_home_dir }
    ensure
      Dotfiles.force = previous_force_value
    end

    def teardown
      if fixture_project_dir or fixture_home_dir
        FileUtils.rm_rf @fixture_dir
      end
    end

    private

      attr_accessor :fixture_project_dir, :fixture_home_dir

      def setup_fixtures
        @fixture_dir = File.join '/tmp', "dotfiles_#{$$}"
        @fixture_project_dir = FileUtils.mkdir_p(File.join(@fixture_dir, "project_dir")).first
        @fixture_home_dir = FileUtils.mkdir_p(File.join(@fixture_dir, "home_dir")).first

        FileUtils.touch File.join(@fixture_project_dir, 'dot_thisrc')
        FileUtils.mkdir_p File.join(@fixture_project_dir, 'dot_this')
        FileUtils.touch File.join(@fixture_project_dir, 'dot_this', 'settings')
        FileUtils.touch File.join(@fixture_project_dir, 'dot_this', 'alias')

        FileUtils.mkdir_p File.join(@fixture_project_dir, 'dot_that', 'plugins')
        FileUtils.touch File.join @fixture_project_dir, 'dot_that', 'plugins', 'foo'
        FileUtils.touch File.join @fixture_project_dir, 'dot_that', 'plugins', 'bar'
      end

      def assert_symlink(link, target)
        assert File.symlink?(link)
        assert_equal File.expand_path(target), File.expand_path(File.readlink(link))
      end
  end
end
