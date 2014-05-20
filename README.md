Keen Event Timeline
========

The `timeline.rb` script pulls events from keen and then builds a timeline of events that span all the event collections.

Setup
-----

In order to use the script, you must have access to a Keen project ID and read key. Set them in the .env file.

```
export KEEN_PROJECT_ID=your_project_id
export KEEN_READ_KEY=your_ready_key
```

Usage
-----

To use this script, do the following (make sure you source the .env file first):

```
$ . .env
$ bundle install
$ bundle exec ruby timeline.rb
```

This produces something like:

```
------------------------------------------------------------
2014-05-18 13:25:56 UTC Member logged in
           Platform:   iPhone
           Browser:    Safari 7.1.1
           Resolution:
------------------------------------------------------------
2014-05-18 13:26:05 UTC Member visited /benefits
           URI:      /benefits
           Referrer: /dashboard
------------------------------------------------------------
2014-05-19 23:31:36 UTC Member logged in
           Platform:   iPhone
           Browser:    Safari 7.1.1
           Resolution:
------------------------------------------------------------
2014-05-19 23:31:47 UTC Member visited /dashboard
           URI:      /dashboard
           Referrer: /
------------------------------------------------------------
2014-05-19 23:31:49 UTC Member visited /benefits
           URI:      /benefits
           Referrer: /dashboard
```
