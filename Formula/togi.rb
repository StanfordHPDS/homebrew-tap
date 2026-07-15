class Togi < Formula
  desc "Polyglot formatter and linter for data science projects: R, Python, Quarto/Markdown, and SQL behind one stable interface"
  homepage "https://github.com/StanfordHPDS/togi"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.0/togi-aarch64-apple-darwin.tar.gz"
      sha256 "09d6c210d52bcf96308fd6ed22d8b72eddbef62b45ff13c1a82a9360e693ab39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.0/togi-x86_64-apple-darwin.tar.gz"
      sha256 "6afbab9f319ffe3042943c7540361d400904ddd25332a08089d93721260f05f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.0/togi-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8af963eaf98a3e5e7a0d957a4b4fdbba341bf27ef24e2fa0dd5b91cb87a8c487"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/togi/releases/download/v0.1.0/togi-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "48c566e7f2393409133df701b00f4de6a73e977d489fb18ef470cfaf87ca40cd"
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
    bin.install "togi" if OS.mac? && Hardware::CPU.arm?
    bin.install "togi" if OS.mac? && Hardware::CPU.intel?
    bin.install "togi" if OS.linux? && Hardware::CPU.arm?
    bin.install "togi" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
