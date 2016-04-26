# encoding: utf-8

require 'net/telnet'
require 'time'
# puppet namespace
module Puppet
  # NetDev namespace
  module NetDev
    # CE namespace
    module CE
      class Command_telnetApi < ApiBase
        def initialize
          super()
        end

        def command_telnet(resource)
          session = Puppet::NetDev::CE::Device.telnet_session

          myfile = File.open('/tmp/hello.txt', 'a')
          t = Time.now
          format = '%Y-%m-%d %H:%M:%S'
          myfile.puts t.strftime(format)

          for i in 0..resource[:command].count - 1 do
            session.cmd('String' => resource[:command][i], 'Match' => /.*/, 'Timeout' => 5) { |c| myfile.puts c }
          end
          session.cmd('String' => 'q', 'Match' => /.*>/, 'Timeout' => 5) { |c| }
          myfile.close
          end
      end
    end
  end
end
