class Hpds < Formula
  desc "Unified tooling for the Stanford HPDS lab: project templates, machine setup, and repo audits"
  homepage "https://github.com/StanfordHPDS/hpds-cli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.2/hpds-aarch64-apple-darwin.tar.gz"
      sha256 "d170e40a1c16bd07aaf1655992587507536e477d348f6de20fa1ac80e36d339e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.2/hpds-x86_64-apple-darwin.tar.gz"
      sha256 "b1f91b8aa5a245c8a3dec03533698d224547f11e85ec94ce5e1197cfc56d6432"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.2/hpds-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ace291bec5dbeb3f01b9ba2e63a85a7b72552fd201be2b7fce8b15bd6448a02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.2/hpds-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ee399d1fb5bc4594a089819edef9cd847bef2174e76cb9944a5be8c6c2b38d78"
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
