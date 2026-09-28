class StalwartCli < Formula
  desc "Stalwart CLI"
  homepage "https://github.com/stalwartlabs/cli"
  version "1.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.13/stalwart-cli-aarch64-apple-darwin.tar.xz"
      sha256 "bde521b9fa035e22cdc7c3f8837a18ce94b975c643a505422bd3738dccda0afc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.13/stalwart-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7b3598f71b9b18c4e1d596769c41bb61945114620434670fb0ed2bb5f3f009a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.13/stalwart-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "65f4b6e528d84388953fc98d946339dd8246fb03bf4caaa64e1d9b378f52d892"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.13/stalwart-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b8509b767edd1a17693e092b518c41610ec4b724f4e62c461bd28cd40c669f7"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "stalwart-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "stalwart-cli"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "stalwart-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "stalwart-cli"
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
