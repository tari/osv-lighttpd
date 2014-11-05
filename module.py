from osv.modules import api

lighttpd = api.run('/lighttpd/lighttpd.so -D -f /lighttpd/lighttpd.conf')
