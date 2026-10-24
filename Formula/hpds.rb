class Hpds < Formula
  desc "Unified tooling for the Stanford HPDS lab: project templates, machine setup, and repo audits"
  homepage "https://github.com/StanfordHPDS/hpds-cli"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.7/hpds-aarch64-apple-darwin.tar.gz"
      sha256 "4bdc3cbed030e85d041b4fe772383d1eb7c81824fc1293d354dd10d2fb461792"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.7/hpds-x86_64-apple-darwin.tar.gz"
      sha256 "143fcc0340a9a0d4ba4ac72bfb297638b936aa77a7e35e62654f22d2b6ce16f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.7/hpds-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f84ebef8c9ee3563a70b1e56e6d05f0435b2d263b47f9c5b1fef07a61a407b69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.7/hpds-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3c9c9a20dd9790269bfa67d9aaf9d9ede67b7630a69460e3d8f083342f74f8d5"
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
