class Hpds < Formula
  desc "Unified tooling for the Stanford HPDS lab: project templates, machine setup, and repo audits"
  homepage "https://github.com/StanfordHPDS/hpds-cli"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.8/hpds-aarch64-apple-darwin.tar.gz"
      sha256 "053e606811d23d078b01c0a4e430da41d1431d50617b09ceac4cc50b100e04ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.8/hpds-x86_64-apple-darwin.tar.gz"
      sha256 "cabd68c14d61d7595cc5a33e869f0bcae5bf174848816285036d028b26cfcefd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.8/hpds-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b8e8352c6d355463e0ed79437539a5c871d16b329c8d2b87e4259e55e4752a1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.8/hpds-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "de6c74efcff098f55636afe5eaed2505f7c206038fc5a0b9414ea2faded5ac32"
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
