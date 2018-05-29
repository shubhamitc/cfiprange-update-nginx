# Author Shubham<Shubhamkr619@gamil.com> 
# assuming you already setup nginx  
# And have a real-ip module loaded.
# You can verify that with nginx -V command 
# Once done include this file /etc/nginx/conf.d/cfront.ipranges.conf in your nginx.conf 
# Licence GPL 
# You are all set

default[:config_common][:nginx_gce_cf_path]='/etc/nginx/conf.d/cfront.ipranges.conf'

service "nginx" do 
	action :start
end

ruby_block 'cf-ip-range-update' do
  block do
    require 'open-uri'
    require 'json'
    status=false
    doc = JSON.parse(open('https://ip-ranges.amazonaws.com/ip-ranges.json').read)
    f=File.open(node[:config_common][:nginx_gce_cf_path])
    text = f.read
    File.open(node[:config_common][:nginx_gce_cf_path],'a') do |o|
        doc['prefixes'].each do |x|
            if x['service'] =='CLOUDFRONT'
                puts "set_real_ip_from #{x['ip_prefix']}; "
                o.write("set_real_ip_from #{x['ip_prefix']}; \n")
            end if !Regexp.new(Regexp.escape(x['ip_prefix'])).match(text)
        end if doc
    end
    f.close
#print text
  end
  action :run
  notifies :reload, 'service[nginx]' 
end

