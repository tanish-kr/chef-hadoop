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

# 2. hadoop archive setting
#cookbook_file node['hadoop']['archive_name'] do
#  path "#{node['hadoop']['src']}#{node['hadoop']['archive_name']}"
##  source node['hadoop']['archive_name']
#  mode 0744
#  action :create_if_missing
#end


cookbook_file node['hadoop']['package_name'] do
  path "#{node['hadoop']['src']}#{node['hadoop']['package_name']}"
  mode 0744
  action :create_if_missing
end

# 3. hadoop install
bash "hadoop_install" do
#  cwd "/home/#{node['hadoop']['user']}"
#  #user 'root'
#  #group 'root'
#  user node['hadoop']['user']
#  group node['hadoop']['user']
  code <<-SHELL
    yum -y --nogpgcheck localinstall #{node['hadoop']['src']}#{node['hadoop']['package_name']}
    rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
  SHELL
#  code <<-SHELL
#    tar -xzf #{node['hadoop']['src']}#{node['hadoop']['archive_name']}
#  SHELL
##  code <<-SHELL
##    wget -P /usr/local/src/ -ivh http://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm
##    rpm -ivh /usr/local/src/cloudera-cdh-5-0.x86_64.rpm
##    rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
##  SHELL
end

##
#  hadoop-yarn-resourcemanager
#  hadoop-hdfs-namenode
#  hadoop-hdfs-secondarynamenode
#  hadoop-yarn-nodemanager
#  hadoop-hdfs-datanode
#
%W(
  hadoop
  hadoop-0.20-conf-pseudo
  hadoop-mapreduce
  hadoop-client
  hadoop-hdfs-namenode
  hadoop-hdfs-datanode
  hadoop-0.20-mapreduce-jobtracker
  hadoop-0.20-mapreduce-tasktracker
).each do |package_name|
  package package_name do
    action :install
  end
end

# setting host name
bash "set_hostname" do
  code <<-SHELL
    echo 127.0.0.1 $(hostname) >> /etc/hosts
  SHELL
  not_if "grep $(hostname) /etc/hosts"
end
# 4. enviroment variable
#template ".bash_profile" do
#  source "bash_profile.erb"
#  #path "/home/#{node['hadoop']['user']}/.bash_profile"
#  path "~/.bash_profile"
#  mode '0644'
#  #owner node['hadoop']['user']
#  #group node['hadoop']['group']
#  #not_if "grep JAVA_HOME /home/#{node['hadoop']['user']}/.bash_profile"
#end

# 5. xml attachment
#%W(
#  core-site.xml
#  hdfs-site.xml
#  mapred-site.xml
#  yarn-site.xml
#).each do |xml|
#    template "#{xml}" do
#    #path "#{node['hadoop']['home']}/etc/hadoop/#{xml}"
#    path "/etc/hadoop/conf/#{xml}"
#    mode '0644'
#    #owner node['hadoop']['user']
#    #group node['hadoop']['group']
#  end
#end
#
#%W(
#  /home/#{node['hadoop']['user']}#{node['hadoop']['hdfs_dir']['namenode']}
#  /home/#{node['hadoop']['user']}#{node['hadoop']['hdfs_dir']['datanode']}
#).each do |dir_name|
##directory "/home/#{node['hadoop']['user']}/#{node['hadoop']['hdfs_dir_name']}" do
#  directory dir_name do
#    owner node['hadoop']['user']
#    group node['hadoop']['group']
#    mode '0755'
#    action :create
#    recursive true
#    #  user node['hadoop']['user']
#    #  code <<-SHELL
#    #    mkdir -p /home/#{node['hadoop']['user']}/#{node['hadoop']['hdfs_dir_name']}
#    #  SHELL
#    #  not_if {Fire.exist?("/home/#{node['hadoop']['user']}/#{node['hadoop']['hdfs_dir_name']}")}
#  end
#end
# hdfs format
bash "hdfs_format" do
  user "hdfs"
  code <<-SHELL
    hdfs namenode -format
  SHELL
end
# hadoop start
#
#  hadoop-yarn-nodemanager
#  hadoop-yarn-resourcemanager
%W(
  hadoop-hdfs-datanode
  hadoop-hdfs-namenode
  hadoop-hdfs-secondarynamenode
  hadoop-0.20-mapreduce-tasktracker
  hadoop-0.20-mapreduce-jobtracker
).each do |service_name|
  service service_name do
    action :start
    #action [:enable, :start]
    #supports :start => true, :stop => true, :restart => true
  end
end



# 6. set hadoop env
#bash "set_hadoop_env" do
#  user node['hadoop']['user']
#  code <<-SHELL
#    echo JAVA_HOME=/usr/lib/jvm/jre >> #{node['hadoop']['home']}/etc/hadoop/hadoop-env.sh
#  SHELL
#  not_if "grep JAVA_HOME #{node['hadoop']['home']}/etc/hadoop/hadoop-env.sh"
#end

# 7.hadoop start
#bash "hadoop_start" do
#  cwd "/home/#{node['hadoop']['user']}"
#  user node['hadoop']['user']
#  code <<-SHELL
#    source /home/#{node['hadoop']['user']}/.bash_profile
#    #{node['hadoop']['home']}/bin/hdfs namenode -format
#    #{node['hadoop']['home']}/sbin/start-dfs.sh
#    #{node['hadoop']['home']}/sbin/start-yarn.sh
#  SHELL
#end
