FRSSS - Friendly RSS Summariser
===============================

This is a little Sinatra app that takes the first segment of the domain that you use to call it, and displays an RSS feed identified by that name. For example, if you contact the server by sending a request to `foo.example.com`, the RSS feed identified by 'foo' will be shown.

The feed that corresponds to a name is determined in one of 2 ways at present. If the name appears in the Mongo collection (a simple pairing of names to URLs), then the feed at the URL paired with that name is used. Otherwise, the name is inserted into a prepared pattern, e.g. 'http://example.com/{NAME}.xml'

Once the RSS feed has been fetched, it's put through an XSL transform that outputs nice, browser-friendly HTML.

Future points of expansion may include:

* Using different XSL transforms for different feeds
* Caching RSS documents