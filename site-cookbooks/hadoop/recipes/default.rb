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
cookbook_file node['hadoop']['archive_name'] do
  path "#{node['hadoop']['src']}#{node['hadoop']['archive_name']}"
#  source node['hadoop']['archive_name']
  mode 0744
  action :create_if_missing
end


# 3. hadoop install
bash "hadoop_install" do
  cwd "/home/#{node['hadoop']['user']}"
  #user 'root'
  #group 'root'
  user node['hadoop']['user']
  group node['hadoop']['user']
  code <<-SHELL
    tar -xzf #{node['hadoop']['src']}#{node['hadoop']['archive_name']}
  SHELL
#  code <<-SHELL
#    wget -P /usr/local/src/ -ivh http://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm
#    rpm -ivh /usr/local/src/cloudera-cdh-5-0.x86_64.rpm
#    rpm --import http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
#  SHELL
end

# 4. enviroment variable
template ".bash_profile" do
  source "bash_profile.erb"
  path "/home/#{node['hadoop']['user']}/.bash_profile"
  mode '0644'
  owner node['hadoop']['user']
  group node['hadoop']['group']
  #not_if "grep JAVA_HOME /home/#{node['hadoop']['user']}/.bash_profile"
end

# 5. xml attachment
%W(
  core-site.xml
  hdfs-site.xml
  mapred-site.xml
  yarn-site.xml
).each do |xml|
    template "#{xml}" do
    path "#{node['hadoop']['home']}/etc/hadoop/#{xml}"
    mode '0644'
    owner node['hadoop']['user']
    group node['hadoop']['group']
  end
end

# 6. set hadoop env
bash "set_hadoop_env" do
  user node['hadoop']['user']
  code <<-SHELL
    echo JAVA_HOME=/usr/lib/jvm/jre >> #{node['hadoop']['home']}/etc/hadoop/hadoop-env.sh
  SHELL
  not_if "grep JAVA_HOME #{node['hadoop']['home']}/etc/hadoop/hadoop-env.sh"
end

# 7.hadoop start
bash "hadoop_start" do
  cwd "/home/#{node['hadoop']['user']}"
  user node['hadoop']['user']
  code <<-SHELL
    source /home/#{node['hadoop']['user']}/.bash_profile
    #{node['hadoop']['home']}/bin/hdfs namenode -format
    #{node['hadoop']['home']}/sbin/start-dfs.sh
    #{node['hadoop']['home']}/sbin/start-yarn.sh
  SHELL
end
