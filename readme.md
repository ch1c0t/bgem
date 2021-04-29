## Introduction

Bgem is a tool to build Ruby gems with less ends. It is available on RubyGems as [bgem][bgem].

When you have to put your code inside of a nested namespace, it could be tedious.
In each file, you have to enclose it. For example, in `lib/m/c/nested_code`
you would have:
```ruby
module M
  class C
    module NestedCode
      def some_method
      end
    end
  end
end
```

Without Bgem: the more files you have, the more times you have to repeat
```ruby
module M
  class C
    # your code
  end
end
```

With Bgem: you can add `bgem/config.rb`

```ruby
output 'lib/m/c/nested_code.rb'
inside 'class C', 'module M'
```

and `src/NestedCode.module.rb`

```ruby
def some_method
end
```

and then, when you run `bundle exec bgem`, a single-file gem will be created
at `lib/m/c/nested_code.rb`.

## Directory structure

Bgem derives how to nest the code from its directory structure in `src`.
Since Bgem is built with Bgem, we can use its code as a usage example.

`tree --charset=ascii src`:

```
src
|-- Bgem
|   |-- Config.class.rb
|   |-- Output.class.rb
|   |-- pre.Output
|   |   |-- Ext
|   |   |   |-- RB
|   |   |   |   |-- Class.class.rb
|   |   |   |   `-- Module.class.rb
|   |   |   `-- RB.module.rb
|   |   |-- Ext.class.rb
|   |   `-- pre.Ext
|   |       `-- StandardHooks.module.rb
|   `-- Write.class.rb
`-- Bgem.module.rb

5 directories, 9 files
```

There are `src/Bgem.module.rb` file and `src/Bgem` directory,
containing the code that all will end up in one file `lib/bgem.rb`
if you run `bundle exec bgem`.

Each file inside `src` must follow the naming convention `Name.type.rb`.
`type` could be either `class` or `module`. `Name` should start with a big
letter since it will be either class or module name.

Each file can have a corresponding directory(for `Name.type.rb` it would be `Name`;
for `Bgem.module.rb` it is `Bgem`). The code from this directory is added **after**
the code from the file:

```
module Bgem
  # code from Bgem.module.rb

  # code from Bgem directory
end
```

If it would be needed, it also could have a corresponding directory for the code
that would be added **before** the code from the file.
It would be called `pre.Bgem`:

```
module Bgem
  # code from pre.Bgem directory

  # code from Bgem.module.rb

  # code from Bgem directory
end
```

## More usage examples

If you would like, you can take a look at

- https://github.com/ch1c0t/hobby-json-keys/blob/main/bgem/config.rb
- https://github.com/ch1c0t/hobby-rpc/blob/main/bgem/config.rb

Any feedback is welcome. Please feel free to reach me out
by email(chertoly@gmail.com) or open an issue.

## Development

To build the project and run the specs:

```
bundle exec rake
```

[bgem]: https://rubygems.org/gems/bgem
