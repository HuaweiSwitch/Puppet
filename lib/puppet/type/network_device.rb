# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# encoding: utf-8

Puppet::Type.newtype(:network_device) do
  @doc = 'Network device resource'

  # Parameters

  newparam(:name, namevar: true) do
    desc 'The network device name'
  end

  newparam(:ipaddress) do
    desc 'The management IP address, e.g. 10.10.10.10'
  end

  newparam(:username) do
    desc 'The username to create a session'
  end

  newparam(:password) do
    desc 'The password to create a session'
  end

  # Properties

  newproperty(:enable) do
    desc 'Enable the session'
    defaultto :true
    newvalues(:true, :false)
  end
end

