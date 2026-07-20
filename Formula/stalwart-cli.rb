class StalwartCli < Formula
  desc "Stalwart CLI"
  homepage "https://github.com/stalwartlabs/cli"
  version "1.0.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.11/stalwart-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1c677b05633e605ffa5b7993e847bc27924401194661564f721671d0d86d3d7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.11/stalwart-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8de11007a3847feec0ae82245c319c0080fcdc2c44e490eb1705d431c3261a14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.11/stalwart-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b84b77fd2ddbf16fe581fa95e7f2799cd730406c9c43d28a4f7e6516f2fe11f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.11/stalwart-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d6e0e58ed841931b819b1c3cff2ebf810f061291d58f5895643811febdb7a5cf"
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
