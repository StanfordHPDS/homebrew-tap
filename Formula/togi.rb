class Togi < Formula
  desc "Polyglot formatter and linter for data science projects: R, Python, Quarto/Markdown, and SQL behind one stable interface"
  homepage "https://github.com/StanfordHPDS/togi"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.2/togi-aarch64-apple-darwin.tar.gz"
      sha256 "84a1d664fde53a9329417d97f91d05181d4868722c17442c306eaeb0a483d0f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.2/togi-x86_64-apple-darwin.tar.gz"
      sha256 "78d51f1caa82062edfd3e9289a1cee93a31ed6f7c15539ba85a0e80694941812"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.2/togi-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bc6eaa6b3ab5854f355b7080aff73e2a11ff99cd059d6342f81d06b519369970"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.2/togi-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7de581df51a2003c430f633e6b30a1c2d3c513e5b683fd884b812d9980ba2e52"
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
