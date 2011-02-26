analdiffist
============

A professional twice over: an analyst and a diffist.

Usage
-------

Diff w/ analysis and metrics for `origin/master..HEAD`:

    $> analdiffist origin/master

    _or use analdiffist's default default, `origin/master`:

    $> analdiffist

Diff w/ analysis and metrics for `origin/master..master`:

    $> analdiffist origin/master..master

Diff each commit in a range:

    $> analdiffist --each origin/master..master


Only show diff 
Sample Output
--------------

TBD

Maybe return codes can be based on positive / negative change?


Contributing to analdiffist
------------------------------
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
--------------------

Copyright (c) 2011 Adam Pearson. See LICENSE.txt for
further details.

