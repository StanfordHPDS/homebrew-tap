class Togi < Formula
  desc "Polyglot formatter and linter for data science projects: R, Python, Quarto/Markdown, and SQL behind one stable interface"
  homepage "https://github.com/StanfordHPDS/togi"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.3/togi-aarch64-apple-darwin.tar.gz"
      sha256 "89d419de20c89f7f87d538fc88e05089a15e9ce54afb2d7c5f71afd812c3f83d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.3/togi-x86_64-apple-darwin.tar.gz"
      sha256 "305c13877d2c9f4cac5634150b45dda76fca9bc75ccf76e9d58403b3258e96cd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.3/togi-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2390ab4cefd513734326e7a6c5885a88960818fbbdaf5be2b5f95fcda5a3d3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.3/togi-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d8a7905f0b3eaa966514765529bfc40ca5a952a6154a75dbe9a5852864a213d5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "togi"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "togi"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "togi"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "togi"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
