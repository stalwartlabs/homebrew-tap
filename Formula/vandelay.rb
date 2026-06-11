class Vandelay < Formula
  desc "JMAP account migration utility"
  homepage "https://github.com/stalwartlabs/vandelay"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.2/vandelay-aarch64-apple-darwin.tar.xz"
      sha256 "ec074843b38ee4dd395fe122c9165fc534887b61427670f4eaf67d000b016030"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.2/vandelay-x86_64-apple-darwin.tar.xz"
      sha256 "88179fbf7fa87911b0052da7ce769c264c0cc2af7ed2985542254f4ce97140bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.2/vandelay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "875bca58fcd9258c6d1793a78534bab117bc152adc6e4a99f61c90bd86b93b3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.2/vandelay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "65650aaa0f04f7727fc985cfd8752e0db6bd098d8851876ac73646da75afc822"
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
