# Homebrew formula for llmtrim (build-from-source).
class Llmtrim < Formula
  desc "Static, deterministic LLM prompt/payload compressor"
  homepage "https://github.com/fkiene/llmtrim"
  url "https://github.com/fkiene/llmtrim/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b7ca02c892f95de559b4e0c034f1a805de03cb2216b1f1260cf5953d5c6098f3"
  license "MPL-2.0"
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
