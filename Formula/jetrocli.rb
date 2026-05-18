class Jetrocli < Formula
  desc "Interactive split-pane TUI for jetro: paste JSON, do live query"
  homepage "https://github.com/mitghi/jetrocli"
  version "0.2.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.11/jetrocli-aarch64-apple-darwin.tar.xz"
      sha256 "a79acafb0111da7f071a0cde06bb236cddbd3b93e5bb171e8fee3221a7fda9db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.11/jetrocli-x86_64-apple-darwin.tar.xz"
      sha256 "ebfa7380c93957112477b6635a1186eb01106c0139908d18f9d3127e6378b30a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.11/jetrocli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc7bcd0617a23c4f99b090c742ee803ba7b019a46dea06a51b8c79484eafa24b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.11/jetrocli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e972b88ecbd721818a635b2f3f05c536103474465b40f715f9a2cd7a9d82a8d4"
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
