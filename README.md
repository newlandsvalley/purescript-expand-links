purescript-expand-links
=======================

This is a very simple utility to macro-expand in the input text all _http_ or _https_ URLS which are free-standing (i.e. those which are not already embedded as HTML attributes).  For example, a URL such as this:

```
   http://foo.com
```

is expanded to:

```html
   <a href="http://foo.com" >http://foo.com<\a>
```

I use it in conjunction with [purescript-html-parser-halogen](https://github.com/rnons/purescript-html-parser-halogen) in order to allow a user to submit text to a server (with or without embedded HTML snippets) and have it returned as active Halogen HTML.


To build
--------

     bower install
     pulp build