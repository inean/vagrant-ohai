module VagrantPlugins
  #
  module Ohai
    #
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-ohai'
      description <<-DESC
      This plugin ensures ipaddress and cloud attributes in Chef
      correspond to Vagrant's private network
      DESC

      VAGRANT_VERSION_REQUIREMENT = '>= 1.7.0'

      # Returns true if the Vagrant version fulfills the requirements
      #
      # @param requirements [String, Array<String>] the version requirement
      # @return [Boolean]
      def self.check_vagrant_version(*requirements)
        Gem::Requirement.new(*requirements).satisfied_by?(
          Gem::Version.new(Vagrant::VERSION))
      end

      # Verifies that the Vagrant version fulfills the requirements
      #
      # @raise [VagrantPlugins::ProxyConf::VagrantVersionError] if this plugin
      # is incompatible with the Vagrant version
      def self.check_vagrant_version!
        unless check_vagrant_version(VAGRANT_VERSION_REQUIREMENT)
          msg = "vagrant-ohai will only work with Vagrant #{VAGRANT_VERSION_REQUIREMENT}"
          $stderr.puts msg
          fail msg
        end
      end

      action_hook(:install_ohai_plugin, Plugin::ALL_ACTIONS) do |hook|
        require_relative 'actions/configure'
        require_relative 'actions/install_plugin'
        hook.before(Vagrant::Action::Builtin::ConfigValidate, Action::Configure)
        hook.after(Vagrant::Action::Builtin::Provision, Action::InstallPlugin)
      end

      config(:ohai) do
        require_relative 'config'
        Config
      end
    end
  end
end
