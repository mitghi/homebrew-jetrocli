class Jetrocli < Formula
  desc "Interactive split-pane TUI for jetro: paste JSON, do live query"
  homepage "https://github.com/mitghi/jetrocli"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.1/jetrocli-aarch64-apple-darwin.tar.xz"
      sha256 "429ed6e5f3d211e8f5541f406739fe314af1afc4275ffba0aa04634773908275"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.1/jetrocli-x86_64-apple-darwin.tar.xz"
      sha256 "31050ac7056f7f2e59c91298449a42b163d265f9dc352366f8774994ab416e0e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.1/jetrocli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e3cf971ed02b9a8cef9eb44f0af6a58cb7a028253fcdef75921936a581f71a03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.1/jetrocli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "406cbfe245eb913dd55150a4f5202db21f573586d769603de266714e07de5853"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "jetrocli" if OS.mac? && Hardware::CPU.arm?
    bin.install "jetrocli" if OS.mac? && Hardware::CPU.intel?
    bin.install "jetrocli" if OS.linux? && Hardware::CPU.arm?
    bin.install "jetrocli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
