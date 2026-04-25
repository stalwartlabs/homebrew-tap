class StalwartCli < Formula
  desc "Stalwart CLI"
  homepage "https://github.com/stalwartlabs/cli"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.2/stalwart-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1f6d89f61e0df30b0fddd18393161cd7366230d2d8941447691bda72e528f2d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.2/stalwart-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b16c290aeadeaf3722e0abaa7eff0f6414195ca670311b12211fded876eb64aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.2/stalwart-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b3a2d50954004cdf86b957878db7825483abebf6dc9190dde8ad758d3819d21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stalwartlabs/cli/releases/download/v1.0.2/stalwart-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "506d425e9d73f05ea99a24131441f638b133daea395fe65a209900181e92a407"
    end
  end
  license any_of: ["AGPL-3.0-only", "LicenseRef-SEL"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
