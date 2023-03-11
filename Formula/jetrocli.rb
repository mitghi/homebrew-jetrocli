class Jetrocli < Formula
  desc "Jetro is a tool for transforming, querying and comparing JSON format"
  homepage "https://github.com/mitghi/jetro"
  url "https://github.com/mitghi/jetrocli/releases/download/v0.1.0/x86_64-darwin-apple-universal-binary.tar.gz"
  sha256 "aa1047b91b88f7f0dd9da59d357f00d8040317b7e2542173e9daa556b9b2d27f"
  version "0.1.0"

  def install
    bin.install "jetrocli"
  end
end
