class Hpds < Formula
  desc "Unified tooling for the Stanford HPDS lab: project templates, machine setup, and repo audits"
  homepage "https://github.com/StanfordHPDS/hpds-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.1/hpds-aarch64-apple-darwin.tar.gz"
      sha256 "0627233cd14f43415001a63519a9ff5299022856a498a6bc8bc0eb5c8688d858"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.1/hpds-x86_64-apple-darwin.tar.gz"
      sha256 "3ab50ede241d802731699b53fd88dc2685e4753d6a82804fdd8e004aebd3cf02"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.1/hpds-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "79554d852813d1a61b5675d4f14fdd52ee4f0c15f9c55849706fdc2948aee98b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.1/hpds-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d862bb42726977d7a2c583bd3c2e5deb49fbab3e2f701701a3dbe12aed2f9d40"
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
    bin.install "hpds" if OS.mac? && Hardware::CPU.arm?
    bin.install "hpds" if OS.mac? && Hardware::CPU.intel?
    bin.install "hpds" if OS.linux? && Hardware::CPU.arm?
    bin.install "hpds" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
