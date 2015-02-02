# ardm-core

A fork of [`dm-core`](https://github.com/datamapper/dm-core).

## Install

Swap out `dm-` gems for `ardm-` and re-bundle.

If a gem is missing, it hasn't been ported yet (there's a lot of them).
Please open an issue on `ardm-core` and I'll get it ported asap.

## About gems in the ardm- namespace

The `ardm-` gems are forks of their respective `dm-` gems rebuilt with a new
gem name and rereleased at the same version number. For example,

    gem 'dm-core', '1.2.1'
    # is mostly the same gem as...
    gem 'ardm-core', '1.2.1'

With a few small caveats, the gems at the same `ardm-` version as `dm-` version
will contain exactly the same lib files.

The exceptions are as follows: Most of the `dm-` gems are too strict on their
gem dependencies. `ardm-` gems are modified to require `~> Major.minor` without
the patch level. This means `ardm-` gems expect SemVer gems. With bundler this
is almost never a problem, since gems are easily locked and upgraded on demand.

The `ardm-` gems all include a `lib/ardm-core.rb` file (matching the gem name)
so that bundler continues to auto-include the gems without a special `require:`
statement.

## Going forward with ardm

Since `ardm` gems don't have the same legacy burden as their `dm` counterparts,
it is possible to be more liberal with releases. Already, 1.3.0 versions are
released for gems which had significant upgrade issues, such as `ardm-rails`,
`ardm-active-model`, and `ardm-core`. At this point, using the newest ardm
gems with versions matching ~> 1.2 (in order to include 1.3 releases) it should
be possible to run rails 4.0 (and maybe 4.1 and 4.2) on ruby 2.0.0.

## What about the `ardm` gem?

The [`ardm`](https://github.com/engineyard/ardm) gem is a project started
with the hopes of shimming datamapper, so that all datamapper behavior can
be used on top of ActiveRecord. It is still in progress and these `ardm-`
gems should assist with the upgrade.

My hope is to make each of these `ardm-` scoped gems compatible with `ardm`
and smart enough to "turn off" their datamapper functionality when `ardm` is
switched to ActiveRecord mode. It may even be possible to scope fixes to the
`ardm-` gem that needs those patches, get the tests passing for each gem,
and thus allow each active record shim to be turned on or off as needed.


