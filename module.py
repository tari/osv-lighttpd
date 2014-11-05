from osv.modules import api

lighttpd = api.run('/lighttpd/lighttpd -D -f /lighttpd/lighttpd.conf')
