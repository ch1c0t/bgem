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
end
