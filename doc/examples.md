# Real-world examples

These examples are based on how bgem is used in xephyr.context and crystal.qemu.

## Example 1: a library class

In xephyr.context, the authored class is:

~~~text
src.source/XephyrContext.class.cr
~~~

Its body can stay focused on the class:

~~~crystal
@display_number : String

def initialize(display_target : String, channel : ::AMQP::Client::Channel)
  @display_number = display_target.delete(':')
  # ...
end
~~~

The project then uses:

~~~sh
bundle exec bgem
~~~

to regenerate the ordinary Crystal source under src/.

This is the useful part of bgem: the authored file does not need to contain the surrounding generated structure just to keep the source modular.

## Example 2: split a class into features

xephyr.context has a Screenshot class plus a pre.Screenshot/ directory.

A feature can live in its own file:

~~~text
src.source/pre.Screenshot/WriteText.cr
~~~

while the main class remains:

~~~text
src.source/Screenshot.class.cr
~~~

After:

~~~sh
bundle exec bgem
~~~

the fragments are assembled into the generated src/screenshot.cr.

This pattern is useful when one class has several independent responsibilities, such as image output and OCR text output.

## Example 3: a namespaced QEMU component

On the grml-agent branch of crystal.qemu, the agent lives at:

~~~text
src.source/QEMU/Agent.class.cr
~~~

Its implementation is deliberately small:

~~~crystal
getter vm : VM
getter context : XephyrContext
getter context_process : ProcessSupervisor

def initialize(@vm : VM = VM.new)
  display = @vm.display
  raise "QEMU VM did not provide a display" if display.nil?

  @context_process = ProcessSupervisor.new(
    "xephyr.context",
    {"DISPLAY_TARGET" => display}
  )
  @context = XephyrContext.new(display, Global.amqp_channel)
end
~~~

The generated src/ tree is what Crystal compiles, but the implementation is maintained in src.source/QEMU/Agent.class.cr.

## Example 4: add an executable

The same crystal.qemu branch has:

~~~text
src.source/bin/grml.agent.cr
~~~

with the end-to-end behavior:

~~~crystal
require "../qemu"

vm = QEMU::VM.new(
  iso_path: "~/Downloads/ISOs/grml-full-2026.09-amd64.iso"
)
agent = QEMU::Agent.new(vm)

if agent.wait_for_text("Press a key")
  puts "GRML Agent: Press a key detected"
else
  puts "GRML Agent: timed out waiting for Press a key"
end

agent.stop
~~~

Its shard.yml target is:

~~~yaml
targets:
  grml.agent:
    main: src/bin/grml.agent.cr
~~~

The complete development loop is therefore:

~~~sh
bundle exec bgem
crystal build src/bin/grml.agent.cr
./src/bin/grml.agent
~~~

## Example 5: update generated targets

xephyr.context demonstrates a useful convention for a project with several commands.

Its authored executable files live in:

~~~text
src.source/bin/
~~~

and include commands such as xephyr.context.inspect and xephyr.sakura.

Running:

~~~sh
bundle exec bgem
~~~

regenerates both the executable source and the shard target declarations.

This means adding a new executable starts with the source file, not a hand-written generated file.

## Debugging a generation problem

When generated Crystal code is surprising, inspect both sides:

~~~sh
sed -n '1,200p' src.source/QEMU/Agent.class.cr
sed -n '1,240p' src/qemu.cr
~~~

Then regenerate:

~~~sh
bundle exec bgem
~~~

If the generated file changes, the problem is in the bgem input or generation rules. If it does not, check whether the source file is actually part of the project's entry-point graph.

This source/generated comparison was particularly useful while developing crystal.qemu and xephyr.context.
