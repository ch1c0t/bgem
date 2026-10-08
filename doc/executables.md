# Executables and shard targets

bgem also assembles Crystal executables from src.source/bin.

## Basic executable

Put the executable entry point here:

~~~text
src.source/bin/grml.agent.cr
~~~

The corresponding generated file is:

~~~text
src/bin/grml.agent.cr
~~~

For a target named grml.agent, the shard target points at the generated file:

~~~yaml
targets:
  grml.agent:
    main: src/bin/grml.agent.cr
~~~

In bgem-managed projects, the target list can be regenerated from the files in src.source/bin.

## Help files

An executable can have a sibling help file:

~~~text
src.source/bin/grml.agent/
  help
~~~

bgem generates the helper code used by the executable's -h/--help handling.

## A practical workflow

Suppose you add:

~~~text
src.source/bin/my.tool.cr
src.source/bin/my.tool/help
~~~

Run:

~~~sh
bundle exec bgem
~~~

Then inspect:

~~~text
src/bin/my.tool.cr
src/bin/my.tool/print_help.cr
~~~

and build the target:

~~~sh
crystal build src/bin/my.tool.cr
~~~

The source executable stays in src.source/bin; the generated executable source belongs under src/bin.

## xephyr.context example

xephyr.context has several executable entry points, including:

~~~text
src.source/bin/xephyr.context.cr
src.source/bin/xephyr.context.inspect.cr
src.source/bin/xephyr.sakura.cr
src.source/bin/xephyr.save_screenshots_and_text.cr
~~~

Its shard.yml contains targets whose main paths point into src/bin.

That makes adding a command straightforward: add the authored entry point, run bgem, and the generated target follows.

## Rake integration

A project can expose bgem through Rake:

~~~ruby
task :bgem do
  sh 'bundle exec bgem'
end
~~~

Then:

~~~sh
bundle exec rake bgem
~~~

is a convenient project-level command.

The current bgem repository itself uses this pattern in its Rakefile.
