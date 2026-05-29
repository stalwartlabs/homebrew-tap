class StalwartCli < Formula
  desc "Stalwart CLI"
  homepage "https://github.com/stalwartlabs/cli"
  version "1.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.8/stalwart-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7aac390c6302b23a1d61773eb53d1c0d6c47e83693a8730211af3d272eec26e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.8/stalwart-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ed2c73a674afdfd87cf93211493cbc3fa607bf6828122cc2231167d626bdd679"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.8/stalwart-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8258a459113353b4908574613b7c9eb24b19085c82fb9fa1a652d2cf84a3c435"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.8/stalwart-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1da5d4ffe11d8aad6ef1a4f7b74843ecc10414e9ea5607ebd16a7aed9138b139"
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
