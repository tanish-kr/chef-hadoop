# 1. java install
%W(
  java-#{node['java']['version']}-openjdk
  java-#{node['java']['version']}-openjdk-devel
  java-#{node['java']['version']}-openjdk-src
).each do |package_name|
  package package_name do
    action :install
  end
end

# 2. hadoop rpm package setting
#cookbook_file node['hadoop']['package_name'] do
#  path "#{node['hadoop']['src']}#{node['hadoop']['package_name']}"
##  source node['hadoop']['package_name']
#  mode 0744
#  action :create_if_missing
#end


# 2. hadoop add repos install
#bash "hadoop_install" do
#  user 'root'
#  group 'root'
#  code <<-SHELL
#    wget -P /usr/local/src/ -ivh http://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm
#    rpm -ivh /usr/local/src/cloudera-cdh-5-0.x86_64.rpm
#    rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
#  SHELL
#end

# 4. hadoop install
#%w(hadoop hadoop-conf-pseudo).each do |package_name|
#  package package_name do
#    action :install
#    source "#{node['hadoop']['src']}#{node['hadoop']['package_name']}"
#    provider Chef::Provider::Package::Rpm
#  end
#end
## 4. hadoop start
#%w(
#    hadoop-datanode
#    hadoop-jobtracker
#    hadoop-namenode
#    hadoop-secondarynamenode
#    hadoop-tasktracker
#).each do |service_name|
#    service service_name do
#        action [ :enable, :start ]
#        supports :start => true, :stop => true, :restart => true
#    end
#end
# 5. enviroment variable
template ".bash_profile" do
  source "bash_profile.erb"
  path "/home/#{node['hadoop']['user']}/.bash_profile"
  mode '0644'
  owner node['hadoop']['user']
  group node['hadoop']['group']
  not_if "grep JAVA_HOME /home/#{node['hadoop']['user']}/.bash_profile"
end
# 6. xml attachment

# 7.hadoop auto start
