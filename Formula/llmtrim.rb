# Homebrew formula for llmtrim (build-from-source).
class Llmtrim < Formula
  desc "Static, deterministic LLM prompt/payload compressor"
  homepage "https://github.com/fkiene/llmtrim"
  url "https://github.com/fkiene/llmtrim/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "5ba72625879b84fe8bede95ce62f6f59533e41f3afe9c2de6cdde59c4d76127b"
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
