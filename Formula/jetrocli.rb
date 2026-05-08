class Jetrocli < Formula
  desc "Interactive split-pane TUI for jetro: paste JSON, do live query"
  homepage "https://github.com/mitghi/jetrocli"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.4/jetrocli-aarch64-apple-darwin.tar.xz"
      sha256 "400ff8567645269124ad98b89d94dbdcfad7e316bd1b77614366c571c13480e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.4/jetrocli-x86_64-apple-darwin.tar.xz"
      sha256 "e0212d58e4486b23747cfc4d1cc24d898a27ffa4dcc58ff762f6d1cb1f0b4e93"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.4/jetrocli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8028a6f7d874fa33e98c011cf68b8936de04034de55edd7eee4b65a95555420c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.4/jetrocli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6bb79405604f0421772fa78661eff06365269ad2a5f3c6b3ccda68332a6128de"
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
