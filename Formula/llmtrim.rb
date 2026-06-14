# Homebrew formula for llmtrim (build-from-source).
class Llmtrim < Formula
  desc "Static, deterministic LLM prompt/payload compressor"
  homepage "https://github.com/fkiene/llmtrim"
  url "https://github.com/fkiene/llmtrim/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "7b2c612eb457bd85da66afde69a6e3583a087bb62f5489c02cb09bd4fe6f7d18"
  license "AGPL-3.0-only"
  head "https://github.com/fkiene/llmtrim.git", branch: "main"

  depends_on "rust" => :build

  def install
    # Since the workspace split the root is a virtual manifest (no [package]) and the
    # binary lives in the llmtrim-cli member. Pre-split tarballs had it at the root, so
    # fall back to "." — the formula then installs any tagged version, old or new.
    crate = File.directory?("crates/llmtrim-cli") ? "crates/llmtrim-cli" : "."
    system "cargo", "install", *std_cargo_args(path: crate)
  end

  test do
    assert_match "llmtrim", shell_output("#{bin}/llmtrim --version")
  end
end
