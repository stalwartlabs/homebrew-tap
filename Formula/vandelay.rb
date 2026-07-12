class Vandelay < Formula
  desc "JMAP account migration utility"
  homepage "https://github.com/stalwartlabs/vandelay"
  version "1.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.6/vandelay-aarch64-apple-darwin.tar.gz"
      sha256 "b74cd1a69df8184bdeca41b0ce45a66c09c213a073ebefcf8cae7846266141e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.6/vandelay-x86_64-apple-darwin.tar.gz"
      sha256 "ac35da855efe053b919231e91a8df24b82317dbc4cecb5b16950f0e9cca7f902"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.6/vandelay-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7b2f640d9b0ad29874812e7d726e0aef9a1941c74d11dd96c2c74488ffc53982"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.6/vandelay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ec5be47bd8755c55e10fbe88b903da2b89c22c3cdd3b0d66ba083e1eac38ccfa"
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
