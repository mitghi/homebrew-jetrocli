class Jetrocli < Formula
  desc "Interactive split-pane TUI for jetro: paste JSON, do live query"
  homepage "https://github.com/mitghi/jetrocli"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.5/jetrocli-aarch64-apple-darwin.tar.xz"
      sha256 "45f32b0e4168aad389f948f4cbfdbe2e9da5e5e24caede572b7923ea0121bab5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.5/jetrocli-x86_64-apple-darwin.tar.xz"
      sha256 "0fd26289cc22201579feb48e00f261d27009564a1761bdae21492551c7a86c8b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.5/jetrocli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3010c7df180b83ee50a8ab2a8f70244ce12361fb39808d49fe68b1110f94855e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mitghi/jetrocli/releases/download/v0.2.5/jetrocli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ebea4585d5c787798a25e8b388f1e1b748e8d7a078a2836103e91c6b557412a1"
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
