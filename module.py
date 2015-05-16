from osv.modules import api

default = api.run('/lighttpd/lighttpd.so -D -f /lighttpd/lighttpd.conf')
