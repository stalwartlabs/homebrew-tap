class Vandelay < Formula
  desc "JMAP account migration utility"
  homepage "https://github.com/stalwartlabs/vandelay"
  version "1.0.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.12/vandelay-aarch64-apple-darwin.tar.gz"
      sha256 "38732b6e906ffe126d863e589d8d717c86a14389538fdb72d88a228b5b3a705b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.12/vandelay-x86_64-apple-darwin.tar.gz"
      sha256 "c79cd0fada89f81fa9b8530f07550cdf3677a9f019c67276f9eba2ac4e010672"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.12/vandelay-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4e86b3651667062e1919cc83ae156b41d7aefd2dacf0ccbb380c2d00634cee3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.12/vandelay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e212eb8f70780149a337c2068bcaa212c3ed470c646cb5713b6a970ff27e9d9f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vandelay"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vandelay"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vandelay"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vandelay"
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
