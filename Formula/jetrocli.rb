class Jetrocli < Formula
  desc "Interactive split-pane TUI for jetro: paste JSON, do live query"
  homepage "https://github.com/mitghi/jetrocli"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.7/jetrocli-aarch64-apple-darwin.tar.xz"
      sha256 "b6be763433fda1147921ac17c22b7439eb344f98b77738a23e42224cda3b5a9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.7/jetrocli-x86_64-apple-darwin.tar.xz"
      sha256 "0849012b016ffe2a6bfa3ea2d8d15e70385d892ddda1d4554ba930f9c7b059ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.7/jetrocli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "01e43586a73a3b45eaa7c162d21a8267fbcf95aaf76754ac5d43a857230777fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.7/jetrocli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50b1fe8eea0ead646290d78ba7fc2e9340eed5db5cebbf1b19b13a1246ef0a70"
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
