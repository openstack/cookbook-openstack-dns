# encoding: UTF-8
#
# Cookbook:: openstack-dns
# Attributes:: default
#
# Copyright:: 2017, x-ion GmbH
# Copyright:: 2017, cloudbau GmbH
# Copyright:: 2019-2020, Oregon State University
#
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
#

%w(public internal).each do |ep_type|
  # openstack dns-api service endpoints (used by users and services)
  default['openstack']['endpoints'][ep_type]['dns-api']['host'] = '127.0.0.1'
  default['openstack']['endpoints'][ep_type]['dns-api']['scheme'] = 'http'
  default['openstack']['endpoints'][ep_type]['dns-api']['port'] = 9001
end
default['openstack']['bind_service']['all']['dns-api']['host'] = '127.0.0.1'
default['openstack']['bind_service']['all']['dns-api']['port'] = 9001

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default['openstack']['dns']['custom_template_banner'] = '
# This file was autogenerated by Chef
# Do not edit, changes will be overwritten
'

default['openstack']['dns']['service_role'] = 'service'
default['openstack']['dns']['syslog']['use'] = false

# Settings for the default pool
default['openstack']['dns']['pool']['ns_hostnames'] = ['ns1.example.org.']
default['openstack']['dns']['pool']['ns_addresses'] = ['127.0.0.1']
default['openstack']['dns']['pool']['masters'] = ['127.0.0.1']
default['openstack']['dns']['pool']['bind_hosts'] = ['127.0.0.1']
default['openstack']['dns']['pool']['rndc_key'] = '/etc/designate/rndc.key'

# platform-specific settings
default['openstack']['dns']['user'] = 'designate'
default['openstack']['dns']['group'] = 'designate'
case node['platform_family']
when 'rhel'
  default['openstack']['dns']['platform'] = {
    'designate_packages' =>
      %w(
        openstack-designate-api
        openstack-designate-central
        openstack-designate-mdns
        openstack-designate-producer
        openstack-designate-worker
        openstack-designate-sink
      ),
    'designate_api_service' => 'designate-api',
    'designate_central_service' => 'designate-central',
    'designate_mdns_service' => 'designate-mdns',
    'designate_producer_service' => 'designate-producer',
    'designate_worker_service' => 'designate-worker',
    'designate_sink_service' => 'designate-sink',
    'package_overrides' => '',
  }
when 'debian'
  default['openstack']['dns']['platform'] = {
    'designate_packages' =>
      %w(
        python3-designate
        designate-api
        designate-central
        designate-mdns
        designate-producer
        designate-worker
        bind9utils
        designate-sink
      ),
    'designate_dashboard_packages' => %w(python3-designate-dashboard),
    'designate_api_service' => 'designate-api',
    'designate_central_service' => 'designate-central',
    'designate_mdns_service' => 'designate-mdns',
    'designate_producer_service' => 'designate-producer',
    'designate_worker_service' => 'designate-worker',
    'designate_sink_service' => 'designate-sink',
    'package_overrides' => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'",
  }
end
