class Hpds < Formula
  desc "Unified tooling for the Stanford HPDS lab: project templates, machine setup, and repo audits"
  homepage "https://github.com/StanfordHPDS/hpds-cli"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.11/hpds-aarch64-apple-darwin.tar.gz"
      sha256 "ea3d23df349f188b122b1ec0ceba1c7d7232c25ec953fee698e8d09e5b577477"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.11/hpds-x86_64-apple-darwin.tar.gz"
      sha256 "84b2db0c44d55340e4382c7ab242424d9ae57e82d8a2b159d1a620dd38e1af64"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.11/hpds-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0f85a55ee587e7c5285828be203b76916ffcc26554b711ede41a240b18421a19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.11/hpds-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f9992e46c59b5c3517718c4a5794fae90072d67634cd79633c873511eca89ae3"
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
      bin.install "hpds"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hpds"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hpds"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hpds"
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
