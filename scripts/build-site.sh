#!/usr/bin/env bash
#
# Build the GitHub Pages site for this tap:
#   <out>/downloads.json            raw aggregated data
#   <out>/badges/<pkg>-downloads.json   shields.io endpoint (install downloads)
#   <out>/badges/<pkg>-version.json     shields.io endpoint (latest tag)
#   <out>/badges/tap-downloads.json     shields.io endpoint (tap-wide total)
#   <out>/index.html                landing page with live previews + copy snippets
#
# Usage: build-site.sh [out_dir]   (default: site)
# Env:   BASE_URL  public URL the site is served from (no trailing slash).
#                  Derived from GITHUB_REPOSITORY when unset.
#
# Requires: gh (authenticated), jq. Reuses aggregate-downloads.sh.

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="${1:-site}"

if [ -z "${BASE_URL:-}" ] && [ -n "${GITHUB_REPOSITORY:-}" ]; then
  owner="${GITHUB_REPOSITORY%%/*}"
  repo="${GITHUB_REPOSITORY#*/}"
  BASE_URL="https://${owner}.github.io/${repo}"
fi
BASE_URL="${BASE_URL:-https://konradmichalik.github.io/homebrew-tap}"

mkdir -p "$out/badges"

json="$out/downloads.json"
bash "$here/aggregate-downloads.sh" > "$json"

count="$(jq -r '.packages | length' "$json" 2>/dev/null || echo 0)"
if [ "${count:-0}" -lt 1 ]; then
  echo "error: aggregate produced no packages; refusing to build an empty site" >&2
  exit 1
fi

# Per-package shields.io endpoint files.
while IFS= read -r name; do
  pkg="$(jq -c --arg n "$name" '.packages[] | select(.name == $n)' "$json")"
  printf '%s' "$pkg" | jq -c '{schemaVersion: 1, label: "downloads", message: (.downloads_install | tostring), color: "orange"}' > "$out/badges/${name}-downloads.json"
  printf '%s' "$pkg" | jq -c '{schemaVersion: 1, label: "version",   message: (.latest.tag // "n/a"),        color: "blue"}'   > "$out/badges/${name}-version.json"
done < <(jq -r '.packages[].name' "$json")

# Tap-wide total.
jq -c '{schemaVersion: 1, label: "homebrew tap", message: ((.totals.downloads_install | tostring) + " downloads"), color: "orange"}' "$json" > "$out/badges/tap-downloads.json"

cards="$(jq -r --arg base "$BASE_URL" '
  .packages
  | map(
      ($base + "/badges/" + .name + "-downloads.json" | @uri) as $denc
      | ($base + "/badges/" + .name + "-version.json"  | @uri) as $venc
      | ("https://img.shields.io/endpoint?url=" + $denc + "&logo=homebrew") as $durl
      | ("https://img.shields.io/endpoint?url=" + $venc + "&logo=homebrew") as $vurl
      | ("[![" + .name + " version](" + $vurl + ")](https://github.com/" + .repo + ")\n"
         + "[![" + .name + " downloads](" + $durl + ")](https://github.com/" + .repo + ")") as $md
      | "<article class=\"card\">"
        + "<div class=\"head\"><h2>" + .name + "</h2><span class=\"type " + .type + "\">" + .type + "</span></div>"
        + "<p class=\"badges\"><img src=\"" + ($vurl | gsub("&"; "&amp;")) + "\" alt=\"version badge\"> "
        + "<img src=\"" + ($durl | gsub("&"; "&amp;")) + "\" alt=\"downloads badge\"></p>"
        + "<textarea readonly rows=\"2\" aria-label=\"Markdown for " + .name + "\">" + ($md | gsub("&"; "&amp;")) + "</textarea>"
        + "<button class=\"copy\" type=\"button\">Copy Markdown</button>"
        + "</article>"
    )
  | join("\n")
' "$json")"

total_dl="$(jq -r '.totals.downloads_install' "$json")"
total_pkgs="$(jq -r '.totals.packages' "$json")"
generated="$(jq -r '.generated_at' "$json")"
tap_enc="$(jq -rn --arg base "$BASE_URL" '($base + "/badges/tap-downloads.json") | @uri')"

cat > "$out/index.html" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Homebrew Tap Badges &middot; konradmichalik/tap</title>
<style>
  :root { color-scheme: light dark; --bg:#0d1117; --fg:#e6edf3; --muted:#8b949e; --card:#161b22; --border:#30363d; --accent:#f9a03f; }
  * { box-sizing: border-box; }
  body { margin:0; font:16px/1.5 -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial,sans-serif; background:var(--bg); color:var(--fg); }
  header { padding:2.5rem 1.25rem 1.5rem; max-width:880px; margin:0 auto; }
  h1 { margin:0 0 .25rem; font-size:1.6rem; }
  header p { margin:.25rem 0; color:var(--muted); }
  code { background:var(--card); padding:.15em .4em; border-radius:5px; border:1px solid var(--border); }
  main { max-width:880px; margin:0 auto; padding:0 1.25rem 3rem; }
  .grid { display:grid; gap:1rem; grid-template-columns:repeat(auto-fill,minmax(380px,1fr)); }
  .card { background:var(--card); border:1px solid var(--border); border-radius:10px; padding:1rem 1.1rem; }
  .head { display:flex; align-items:center; gap:.6rem; margin-bottom:.6rem; }
  .head h2 { margin:0; font-size:1.15rem; }
  .type { font-size:.7rem; text-transform:uppercase; letter-spacing:.05em; padding:.1rem .5rem; border-radius:999px; border:1px solid var(--border); color:var(--muted); }
  .badges { display:flex; gap:.4rem; flex-wrap:wrap; margin:.2rem 0 .7rem; min-height:20px; }
  textarea { width:100%; font:13px/1.4 ui-monospace,SFMono-Regular,Menlo,monospace; background:var(--bg); color:var(--fg); border:1px solid var(--border); border-radius:6px; padding:.5rem; resize:vertical; }
  button.copy { margin-top:.5rem; cursor:pointer; background:var(--accent); color:#1a1300; border:0; border-radius:6px; padding:.45rem .9rem; font-weight:600; }
  button.copy:hover { filter:brightness(1.08); }
  footer { max-width:880px; margin:0 auto; padding:0 1.25rem 3rem; color:var(--muted); font-size:.85rem; }
  a { color:var(--accent); }
</style>
</head>
<body>
<header>
  <h1>Homebrew Tap Badges</h1>
  <p><img src="https://img.shields.io/endpoint?url=${tap_enc}&amp;logo=homebrew" alt="tap total downloads"></p>
  <p>Embeddable badges for <code>konradmichalik/tap</code> &mdash; ${total_pkgs} packages, ${total_dl} install downloads total.</p>
  <p>Copy a snippet below into a project README. Badges render via <a href="https://shields.io">shields.io</a> from JSON hosted here; they update when this page redeploys.</p>
</header>
<main>
  <div class="grid">
${cards}
  </div>
</main>
<footer>
  <p>Generated ${generated} &middot; data from GitHub release download counts (<code>.dmg</code> / <code>.tar.gz</code> assets).</p>
</footer>
<script>
  document.querySelectorAll("button.copy").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var ta = btn.parentElement.querySelector("textarea");
      navigator.clipboard.writeText(ta.value).then(function () {
        var old = btn.textContent;
        btn.textContent = "Copied!";
        setTimeout(function () { btn.textContent = old; }, 1500);
      });
    });
  });
</script>
</body>
</html>
HTML

echo "Built site in '$out' (base: $BASE_URL)" >&2
