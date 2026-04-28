class StalwartCli < Formula
  desc "Stalwart CLI"
  homepage "https://github.com/stalwartlabs/cli"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.4/stalwart-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ff7fe6ccca16cfedabd54c289d2160a237efd47d23380ab4210f93ff2968e7da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.4/stalwart-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c03af055a23928664acf8ad7e93673bb946abb6b2c5ca65774d04df045047b23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.4/stalwart-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d6e8642f1e500c2f85eb477f469f1e47979c5394533b4ddf2e423fe21b953385"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.4/stalwart-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15376c8d50a5640ded178d4820d3065e5315634aff9981986c5649c914bf170d"
    end
  end
  license any_of: ["AGPL-3.0-only", "LicenseRef-SEL"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":                   {},
    "aarch64-unknown-linux-gnu":              {},
    "aarch64-unknown-linux-musl-dynamic":     {},
    "aarch64-unknown-linux-musl-static":      {},
    "arm-unknown-linux-gnueabihf":            {},
    "arm-unknown-linux-musl-dynamiceabihf":   {},
    "arm-unknown-linux-musl-staticeabihf":    {},
    "armv7-unknown-linux-gnueabihf":          {},
    "armv7-unknown-linux-musl-dynamiceabihf": {},
    "armv7-unknown-linux-musl-staticeabihf":  {},
    "x86_64-apple-darwin":                    {},
    "x86_64-pc-windows-gnu":                  {},
    "x86_64-unknown-linux-gnu":               {},
    "x86_64-unknown-linux-musl-dynamic":      {},
    "x86_64-unknown-linux-musl-static":       {},
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
    bin.install "stalwart-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "stalwart-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "stalwart-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "stalwart-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
