
Litmus Reseller Email Analytics
===============================

This is a simple wrapper around the Litmus *reseller* Email Analytics API - 
see the (at this writing) 
[limited documentation](http://http://docs.litmus.com/w/page/31510574/Email%20Analytics%20SOAP%20API)

Install
-------
`gem install litmus_resmail`


Example Usage
-------------
    api = LitmusResmail::Analytics.new('user', 'pw')
    report = api.create

Caveats
-------
This is my first gem, and I am not a full-time Ruby programmer.  So, go
easy on me.
