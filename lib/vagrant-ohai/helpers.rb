module VagrantPlugins
  #
  module Ohai
    #
    module Helpers
      def chef_provisioners
        @machine.config.vm.provisioners.find_all do |provisioner|
          [:chef_client, :chef_solo, :chef_zero].include? provisioner.type
        end
      end
    end
  end
end
