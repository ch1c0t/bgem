# Source layout

The key bgem convention is that a structured source tree can be assembled into a normal Crystal source tree.

## Class and module files

A file such as:

~~~text
src.source/XephyrContext.class.cr
~~~

describes a class body. The generated source wraps that body in the corresponding Crystal class.

For a namespaced component, the source tree can be split further. crystal.qemu, for example, keeps QEMU components under:

~~~text
src.source/QEMU/
~~~

A component can therefore be maintained in a small file without forcing the generated src/ tree to have the same layout.

## require files

A sibling .require file declares Crystal require statements that bgem puts into the generated file.

For example:

~~~text
src.source/XephyrContext.require
~~~

is used to assemble the dependencies needed by the generated XephyrContext source.

## pre.* directories

A pre.<Name>/ directory contains source fragments that are inserted before the main generated body.

This is useful for support code that must appear before a class or module body. xephyr.context uses this style for pieces such as pre.Screenshot/.

The practical pattern is:

~~~text
src.source/
  Screenshot.class.cr
  pre.Screenshot/
    WriteImage.cr
    WriteText.cr
~~~

Keep the fragments focused; bgem concatenates them into the generated source.

## Entry files

Top-level .cr files in src.source/ are entry points for generated library files.

The generated filename is derived from the entry name. A project can therefore keep a structured collection such as:

~~~text
src.source/
  XephyrContext.class.cr
  XephyrContext.require
  QEMU.cr
  QEMU.require
~~~

while exposing ordinary generated files under src/.

## Regeneration

After changing any file under src.source/, regenerate:

~~~sh
bundle exec bgem
~~~

Then inspect the generated src/ file when debugging what Crystal actually compiles.

A useful mental model is:

~~~text
src.source/   --(bgem)-->   src/
     authored                  generated
~~~

The generated tree is an artifact, not the place to make the next source change.
