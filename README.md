analdiffist
============

A professional twice over: an analyst and a diffist.
[http://www.youtube.com/watch?v=UrIpPqcln6Y](http://www.youtube.com/watch?v=UrIpPqcln6Y)

analdiffist uses [flog](http://ruby.sadi.st/Flog.html) and [reek](https://github.com/kevinrutherford/reek/wiki) to analyze ruby code.
Given two git refs (for example *master* and *feature-branch*), it will show you any differences in code metrics introduced between the refs.

Usage
-------

analdiffist [*ref-1*] [*ref-2*]

If not supplied, ref-1 defaults to *origin/master* and ref-2 defaults to the current head. 

note that before starting, analdiffist will stash your local changes, if any exist. After running, it will unstash your changes, leaving your local tree untouched... I think. No warranties are made.

Diff w/ analysis and metrics for `origin/master..HEAD`:

    $> analdiffist origin/master

_or use analdiffist's default default, which is the common ancestor of HEAD and origin/master:

    $> analdiffist

Diff w/ analysis and metrics for `origin/master..master`:

    $> analdiffist origin/master master

Future
------

Diff each commit in a range (once we implement this):

    $> analdiffist origin/master..master


Sample Output
--------------



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

