
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
These are API calls I have seen work and return results that make some
sense to me.
    api = LitmusResmail::Analytics.new('user', 'pw')
    # create a new campaign
    campaign = api.create

    campaign.bug_html   # the HTML to put in your newsletter
    guid = campaign.guid
    result = api.start_campaign(guid)

    # useful to verify that create worked
    result = api.get_campaign_meta_data(guid)

    # shows simple read vs. skimmed stats - does not count Gmail users!
    result = api.get_engagement_report(guid)

Caveats
-------
This is my first gem, and I am not a full-time Ruby programmer.  So, go
easy on me.
