# Homebrew formula for llmtrim (build-from-source).
class Llmtrim < Formula
  desc "Static, deterministic LLM prompt/payload compressor"
  homepage "https://github.com/fkiene/llmtrim"
  url "https://github.com/fkiene/llmtrim/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "d62e43341fba8a78f2f34dab7f1f63cb9c7b7c8f55da5aa74c72f1b62a82dc1b"
  license "MPL-2.0"
  head "https://github.com/fkiene/llmtrim.git", branch: "main"

  depends_on "rust" => :build

  def install
    # Since the workspace split the root is a virtual manifest (no [package]) and the
    # binary lives in the llmtrim-cli member. Pre-split tarballs had it at the root, so
    # fall back to "." — the formula then installs any tagged version, old or new.
    crate = File.directory?("crates/llmtrim-cli") ? "crates/llmtrim-cli" : "."
    system "cargo", "install", *std_cargo_args(path: crate)

    # The desktop tray (llmtrim-tray) is a separate member, present only on tagged
    # post-split tarballs and built from source like the CLI. The committed frontend
    # dist/ ships in the tarball, so the build needs no Node toolchain. macOS only:
    # it uses WKWebView (a system framework), so no extra deps are needed, whereas
    # Linuxbrew would need WebKitGTK + AppIndicator at link time (not declared here);
    # Linux users get the tray from the GitHub Release asset instead.
    if File.directory?("crates/llmtrim-tray")
      on_macos do
        system "cargo", "install", *std_cargo_args(path: "crates/llmtrim-tray")
      end
    end
  end

  test do
    assert_match "llmtrim", shell_output("#{bin}/llmtrim --version")
  end
end
