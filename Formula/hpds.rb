class Hpds < Formula
  desc "Unified tooling for the Stanford HPDS lab: project templates, machine setup, and repo audits"
  homepage "https://github.com/StanfordHPDS/hpds-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.0/hpds-aarch64-apple-darwin.tar.gz"
      sha256 "3d8c0a11649ad63d4194b64cc9bc4a959c57e9ec7852c5ef17b177699a687c92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.0/hpds-x86_64-apple-darwin.tar.gz"
      sha256 "658a7dd7ef473a00da7fc1f2f9fadb38ed9f032b65e31e6def1d65115bfcef70"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.0/hpds-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cc28620b3dbab9f6f82cff5075821bef5f7136d8b5028564631b52dec9288c83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/StanfordHPDS/hpds-cli/releases/download/v0.1.0/hpds-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9f0082c9cae0c1e7d7954e107fd96a664df2dc5235a1a6973e54cea118e0ecf5"
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
