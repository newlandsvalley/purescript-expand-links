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

It also includes a function to macro-expand simple YouTube watch URLS as embedded iframe links, allowing the user to submit a simple URL and have it returned as an active embedded video.  For example:


```
   http://www.youtube.com/watch?v=7fw2eTvYUcE
```

is expanded to:

```html
  <iframe width='420' height='315' src='//www.youtube.com/embed/7fw2eTvYUcE' frameborder='0' allowfullscreen='true'></iframe>
```


I use it in conjunction with [purescript-html-parser-halogen](https://github.com/rnons/purescript-html-parser-halogen) in order to allow a user to submit text to a server (with or without embedded HTML snippets) and have it returned as active Halogen HTML.


To build
--------

     bower install
     pulp build