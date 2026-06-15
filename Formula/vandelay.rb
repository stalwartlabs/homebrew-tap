class Vandelay < Formula
  desc "JMAP account migration utility"
  homepage "https://github.com/stalwartlabs/vandelay"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.3/vandelay-aarch64-apple-darwin.tar.xz"
      sha256 "5c599791b3b1003f3eca4b4c107865728d3a4abfb1a9ab2e65995f662f2401e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.3/vandelay-x86_64-apple-darwin.tar.xz"
      sha256 "a71303189558ab2034a9605430c387c173f74013a6c610453b94f84b1fc6242f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.3/vandelay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7e76be73dcb74393a4d823a26a9f1fe3100282a645eed1c33423875c1b28234"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/vandelay/releases/download/v1.0.3/vandelay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c8bdca3c8eebb97a1554b8f1cfbc626e94d8a2fdecbb0171c1dea4aebe8ec46"
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
