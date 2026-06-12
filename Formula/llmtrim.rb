# Homebrew formula for llmtrim (build-from-source).
class Llmtrim < Formula
  desc "Static, deterministic LLM prompt/payload compressor"
  homepage "https://github.com/fkiene/llmtrim"
  url "https://github.com/fkiene/llmtrim/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "00bdc2d39a04dd74c42966e849b85e859292c5bf5dfe63ec9899d2bae1e6bfe4"
  license "AGPL-3.0-only"
  head "https://github.com/fkiene/llmtrim.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "llmtrim", shell_output("#{bin}/llmtrim --version")
  end
end
