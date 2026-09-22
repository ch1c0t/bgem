shared_examples 'crystal_clib' do
  let(:src) { Pathname 'src' }

  it 'creates a lib' do
    file = src.join 'c.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
lib C
  fun openpty(amaster : Int32*, aslave : Int32*, name : UInt8*, termp : Void*, winp : Void*) : Int32
  fun login_tty(fd : Int32) : Int32
  fun fork : Int32
  fun _exit(status : Int32) : NoReturn
end
    S
    expect(file.read).to eq expected
  end

  it 'adds a preamble' do
    file = src.join 'lib_x11.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
@[Link("X11")]
lib LibX11
  alias Window = LibC::ULong
  alias Drawable = LibC::ULong
end
    S
    expect(file.read).to eq expected
  end

  it 'incorporates nested structures' do
    file = src.join 'lib_x.cr'
    expect(file.file?).to be true

    expected = <<~S.chomp
lib LibX
  alias Window = LibC::ULong
  alias Drawable = LibC::ULong
  
  struct XAnyEvent
    type : LibC::Int
    serial : LibC::ULong
    send_event : LibC::Int
    display : Display
    window : Window
  end
  
  struct XEvent
    type : LibC::Int
    pad : LibC::Long[24]
  end
  
  fun XFree(data : Void*) : LibC::Int
  fun XNextEvent(display : Display, event_return : XEvent*) : LibC::Int
end
    S
    expect(file.read).to eq expected
  end
end
