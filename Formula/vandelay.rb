class Vandelay < Formula
  desc "JMAP account migration utility"
  homepage "https://github.com/stalwartlabs/vandelay"
  version "1.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.7/vandelay-aarch64-apple-darwin.tar.gz"
      sha256 "7b3de8c32e20b5174141b7793e4cef142c5a2ed6a2f28e001d21e4a55990be97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.7/vandelay-x86_64-apple-darwin.tar.gz"
      sha256 "4a0b2729f0ad19bcf176926c8077738eaca374f3a2f8dbea6ec3991481f932c6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.7/vandelay-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4afa42b4387de3e7420e1e86ca198c5bad943b05479b144d53a16899a17363a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.7/vandelay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ea66a2616a807d8aea6f50c16e0d3193fe0fe24380ce49fa784b0d0029f3d6fe"
    end
  end
  license any_of: ["Apache-2.0", "MIT"]

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
    bin.install "vandelay" if OS.mac? && Hardware::CPU.arm?
    bin.install "vandelay" if OS.mac? && Hardware::CPU.intel?
    bin.install "vandelay" if OS.linux? && Hardware::CPU.arm?
    bin.install "vandelay" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
