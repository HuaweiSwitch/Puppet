# encoding: utf-8

require 'net/telnet'
require_relative '/opt/puppetlabs/puppet/lib/ruby/gems/2.1.0/gems/net-ssh-2.9.2/lib/net/ssh/Stelnet-common.rb'
require 'time'
# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class Command_sshApi < ApiBase
        def initialize
          super()
        end

        def command_ssh(resource)
          session = Puppet::NetDev::CE::Device.ssh_session
          myFile = File.open('/tmp/hello.txt', 'a')
          t = Time.now
          format = '%Y-%m-%d %H:%M:%S'
          myFile.puts t.strftime(format)

          for i in 0..resource[:command].count - 1 do
            session.write(resource[:command][i] + "\n")
            session.waitfor('Match' => /<>/, 'Timeout' => 5) { |c| myFile.puts c }
          end
          myFile.close
          end
      end
    end
  end
end
