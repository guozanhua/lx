LX web platform framework
=========================


LX is a MVC framework.  LX was not designed to be a website framework but a
web platform framework.  The difference lies in the fact that LX applications
appear as websites only if they are opened within a web browser.

The default implementation uses PHP and MySQL, but LX can be extended to use
any language/DBMS.

LX relies on a W3C standard called XSL to transform XML declaration files into
configuration and implementation files.  XSL is also used to manage templates
and layouts to keep the view completely separated from the controllers and
can be cached by the web browser.  In fact, it is perfectly suitable for REST
applications.


Installation
------------

1. Clone the repository
2. Make sure the PHP interpreter is in your `$PATH`
3. Add an environment variable `$LX_HOME` set to `/path/to/lx/framework`
4. Add `$LX_HOME/bin` to your `$PATH`

It should work on Linux, Windows and Mac.


Usage
-----

You should use `lx-cli` to manage your project:

* `lx-cli create <project>` -- deploy *project* skeleton in current directory
* `lx-cli create <project> [archetype]` -- deploy *project* specific *archetype* skeleton in current directory
* `lx-cli update` -- update both configuration files and models
* `lx-cli update config` -- update configuration files
* `lx-cli update models` -- update models
* `lx-cli update lib` -- force a copy of the lib again (useful after git update) (Windows < Vista/7 only)
* `lx-cli help` -- display commands


Troubleshooting
---------------

### Check your cache ###
Since the transformation is done client-side, you can expect your browser to cache the stylesheet.  It's recommended that you disable your cache while developing.

### Make sure the generated code is up-to-date ###
Run `lx-cli` every time you change your models.

### Define your document root in the configuration ###
If the URL doesn't start on the server root, make sure you define `<lx:const name="LX_DOCUMENT_ROOT" value="'/path'"/>`.

### Where are the errors? ###
1. In the current view (if you have defined `<lx:const name="LX_DEBUG" value="true"/>`)
2. In the XML response (add .xml to the end of the URL)
3. In the log file of your HTTP server's language extension


Contribute
----------

`lx` is LGPL-licensed.  Make sure you tell us everything that's wrong!

* [Source code](https://github.com/aerys/lx)
* [Issue tracker](https://github.com/aerys/lx/issues)
