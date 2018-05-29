require 'open-uri'
require 'json'
status=false
doc = JSON.parse(open('https://ip-ranges.amazonaws.com/ip-ranges.json').read)
f=File.open('/etc/nginx/conf.d/cfront.ipranges.conf')
text = f.read
File.open('/etc/nginx/conf.d/cfront.ipranges.conf','a') do |o|
    doc['prefixes'].each do |x|
        if x['service'] =='CLOUDFRONT'
            puts "set_real_ip_from #{x['ip_prefix']}; "
            o.write("set_real_ip_from #{x['ip_prefix']}; \n")
        end if !Regexp.new(Regexp.escape(x['ip_prefix'])).match(text)
    end if doc
end
f.close
#print text
