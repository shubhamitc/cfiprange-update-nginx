# cfiprange-update-nginx
Cloudfront ip range update for nginx set_real_ip module. Use case:
* Be able to find correct user ips using real_ip module
* Once real_ip is found user can write map or if in nginx to block the requests
* Dynamically update CF ip range after some interval
