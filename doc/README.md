# bgem

bgem is the source generator used by these Crystal projects to keep authored source in a structured src.source/ tree while producing ordinary Crystal files under src/.

The basic workflow is:

~~~sh
bundle install
bundle exec bgem
~~~

In the projects documented here, src.source/ is the authored source and src/ is generated output. Edit the former, regenerate the latter, and build from the generated tree.

## Guides

- [Source layout](source-layout.md) — how src.source/ maps into src/.
- [Executables and shard targets](executables.md) — how src.source/bin becomes Crystal targets.
- [Real-world examples](examples.md) — patterns taken from xephyr.context and crystal.qemu.

## The important rule

Do not hand-edit generated src/ files in a bgem-managed project.

For example, in xephyr.context, the authored file:

~~~text
src.source/XephyrContext.class.cr
~~~

contains the body of the XephyrContext class, while bgem assembles the generated Crystal source that is required by the shard.

Likewise, crystal.qemu keeps QEMU::Agent in:

~~~text
src.source/QEMU/Agent.class.cr
~~~

and regenerates the corresponding src/ output.

## Rebuild after source changes

From the project root:

~~~sh
bundle exec bgem
crystal build src/bin/your_target.cr
~~~

If the project has a Rake task for bgem, the equivalent is commonly:

~~~sh
bundle exec rake bgem
~~~

The repository's own Rakefile remains the source of truth for its available tasks.
