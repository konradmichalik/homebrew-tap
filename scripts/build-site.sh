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
  | to_entries
  | map(
      .key as $i
      | .value as $p
      | (($i + 1) | tostring | if (length < 2) then "0" + . else . end) as $num
      | ($base + "/badges/" + $p.name + "-downloads.json" | @uri) as $denc
      | ($base + "/badges/" + $p.name + "-version.json"  | @uri) as $venc
      | ("https://img.shields.io/endpoint?url=" + $denc + "&style=flat-square&logo=homebrew") as $durl
      | ("https://img.shields.io/endpoint?url=" + $venc + "&style=flat-square&logo=homebrew") as $vurl
      | ("[![" + $p.name + " version](" + $vurl + ")](https://github.com/" + $p.repo + ")\n"
         + "[![" + $p.name + " downloads](" + $durl + ")](https://github.com/" + $p.repo + ")") as $md
      | "<article class=\"pkg\" style=\"--i:" + ($i | tostring) + "\">"
        + "<span class=\"idx\">" + $num + "</span>"
        + "<div class=\"pkg-body\">"
        + "<div class=\"pkg-top\">"
        + "<div class=\"title\"><h2 class=\"name\">" + $p.name + "</h2><span class=\"chip " + $p.type + "\">" + $p.type + "</span></div>"
        + "<div class=\"badges\">"
        + "<img src=\"" + ($vurl | gsub("&"; "&amp;")) + "\" alt=\"" + $p.name + " version\" loading=\"lazy\"> "
        + "<img src=\"" + ($durl | gsub("&"; "&amp;")) + "\" alt=\"" + $p.name + " downloads\" loading=\"lazy\">"
        + "</div>"
        + "</div>"
        + "<details class=\"embed\"><summary>Markdown</summary>"
        + "<div class=\"code-wrap\"><pre><code>" + ($md | gsub("&"; "&amp;")) + "</code></pre>"
        + "<button class=\"copy\" type=\"button\" aria-label=\"Copy Markdown for " + $p.name + "\"><span class=\"copy-label\">Copy</span></button></div>"
        + "</details>"
        + "</div>"
        + "</article>"
    )
  | join("\n")
' "$json")"

total_dl="$(jq -r '.totals.downloads_install' "$json")"
total_pkgs="$(jq -r '.totals.packages' "$json")"
generated="$(jq -r '.generated_at' "$json")"
gen_date="${generated%%T*}"
tap_enc="$(jq -rn --arg base "$BASE_URL" '($base + "/badges/tap-downloads.json") | @uri')"

if [ -n "${GITHUB_REPOSITORY:-}" ]; then
  tap_url="https://github.com/${GITHUB_REPOSITORY}"
else
  tap_url="https://github.com/konradmichalik/homebrew-tap"
fi

cat > "$out/index.html" <<HTML
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="theme-color" content="#f4f1ea">
<title>Homebrew Tap &middot; Badge Gallery</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Hanken+Grotesk:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
  :root {
    color-scheme: light;
    --paper:#f4f1ea; --surface:#fffdf8; --ink:#1a1613; --muted:#857c6d;
    --line:#e6ded1; --amber:#bd5b1a; --amber-2:#e0832f;
    --mono:"JetBrains Mono",ui-monospace,SFMono-Regular,Menlo,monospace;
    --sans:"Hanken Grotesk",system-ui,-apple-system,sans-serif;
  }
  * { box-sizing:border-box; }
  html { -webkit-text-size-adjust:100%; }
  body { margin:0; background:var(--paper); color:var(--ink); font-family:var(--sans); font-size:16px; line-height:1.5; -webkit-font-smoothing:antialiased; }
  body::before { content:""; position:fixed; inset:0; z-index:-1; pointer-events:none;
    background:radial-gradient(110% 70% at 50% -15%, rgba(189,91,26,.07), transparent 62%); }
  .wrap { max-width:840px; margin:0 auto; padding:0 clamp(1.25rem,5vw,2.25rem); }
  a { color:var(--amber); text-underline-offset:3px; }

  .hero { padding:clamp(3.25rem,9vw,6rem) 0 2.75rem; border-bottom:1px solid var(--line); }
  .kicker { font-family:var(--mono); font-size:.7rem; text-transform:uppercase; letter-spacing:.12em; color:var(--amber); margin:0 0 1.1rem; }
  h1 { font-family:var(--sans); font-weight:600; font-size:clamp(1.85rem,4.5vw,2.8rem); line-height:1.1; letter-spacing:-.02em; margin:0; color:var(--ink); }
  h1 em { font-style:normal; color:var(--amber); }
  .lede { font-size:1.05rem; color:var(--muted); max-width:50ch; margin:1.3rem 0 0; }
  .stats { display:flex; gap:clamp(2rem,7vw,4rem); margin-top:2.4rem; }
  .stat .n { font-family:var(--sans); font-weight:600; font-size:clamp(1.6rem,4vw,2.1rem); line-height:1; color:var(--ink); letter-spacing:-.01em; }
  .stat .l { font-family:var(--mono); font-size:.66rem; text-transform:uppercase; letter-spacing:.1em; color:var(--muted); margin-top:.5rem; }
  .tap { display:flex; align-items:center; gap:1rem 1.4rem; flex-wrap:wrap; margin-top:2.4rem; }
  .tap-label { font-family:var(--mono); font-size:.66rem; text-transform:uppercase; letter-spacing:.1em; color:var(--muted); }
  .tap img { height:22px; display:block; }

  .section { font-family:var(--mono); font-size:.7rem; font-weight:500; text-transform:uppercase; letter-spacing:.1em; color:var(--muted); margin:3rem 0 .25rem; }
  .section b { color:var(--amber); font-weight:500; }

  .pkg { display:flex; gap:clamp(1rem,4vw,2.4rem); padding:1.7rem 0; border-top:1px solid var(--line); }
  .pkg:first-of-type { border-top:0; }
  .idx { font-family:var(--mono); font-size:.92rem; color:var(--muted); padding-top:.4rem; min-width:2.2ch; letter-spacing:.04em; transition:color .2s; }
  .pkg:hover .idx { color:var(--amber); }
  .pkg-body { flex:1; min-width:0; }
  .pkg-top { display:flex; align-items:baseline; justify-content:space-between; gap:1rem; flex-wrap:wrap; }
  .title { display:flex; align-items:baseline; gap:.7rem; flex-wrap:wrap; }
  .name { font-family:var(--mono); font-weight:500; font-size:clamp(1.05rem,2.6vw,1.3rem); margin:0; color:var(--ink); letter-spacing:-.01em; }
  .chip { font-family:var(--mono); font-size:.6rem; text-transform:uppercase; letter-spacing:.08em; color:var(--muted); border:1px solid var(--line); padding:.18rem .5rem; border-radius:3px; }
  .chip.cask { color:var(--amber); border-color:rgba(189,91,26,.35); }
  .badges { display:inline-flex; align-items:center; gap:.45rem; min-height:22px; }
  .badges img { height:22px; display:block; }

  .embed { margin-top:1rem; }
  .embed summary { font-family:var(--mono); font-size:.7rem; text-transform:uppercase; letter-spacing:.08em; color:var(--muted); cursor:pointer; list-style:none; display:inline-flex; align-items:center; gap:.5rem; user-select:none; transition:color .15s; }
  .embed summary::-webkit-details-marker { display:none; }
  .embed summary::before { content:"</>"; color:var(--amber); font-weight:700; }
  .embed summary:hover, .embed[open] summary { color:var(--ink); }
  .code-wrap { position:relative; margin-top:.75rem; }
  pre { margin:0; background:var(--surface); border:1px solid var(--line); border-radius:8px; padding:.9rem 1rem; overflow-x:auto; }
  code { font-family:var(--mono); font-size:.76rem; line-height:1.65; color:#5f5749; white-space:pre; }
  .copy { position:absolute; top:.55rem; right:.55rem; font-family:var(--mono); font-size:.62rem; text-transform:uppercase; letter-spacing:.08em; cursor:pointer; background:var(--paper); color:var(--muted); border:1px solid var(--line); border-radius:5px; padding:.32rem .6rem; transition:all .15s; }
  .copy:hover { color:var(--amber); border-color:var(--amber); }
  .copy[data-copied="true"] { color:#fff; background:var(--amber); border-color:var(--amber); }

  .footer { border-top:1px solid var(--line); margin-top:2.5rem; padding:2rem 0 4rem; font-family:var(--mono); font-size:.7rem; color:var(--muted); line-height:1.8; }

  @media (prefers-reduced-motion: no-preference) {
    @keyframes up { from { opacity:0; transform:translateY(14px); } to { opacity:1; transform:none; } }
    .hero > * { animation:up .7s cubic-bezier(.2,.7,.2,1) backwards; }
    .kicker { animation-delay:.04s; } h1 { animation-delay:.1s; } .lede { animation-delay:.2s; }
    .stats { animation-delay:.3s; } .tap { animation-delay:.4s; }
    .pkg { animation:up .6s cubic-bezier(.2,.7,.2,1) backwards; animation-delay:calc(var(--i) * 55ms + .45s); }
  }
</style>
</head>
<body>
<div class="wrap">
  <header class="hero">
    <p class="kicker">konradmichalik / tap</p>
    <h1>Homebrew tap <em>badges</em></h1>
    <p class="lede">Live version and download badges for every cask and formula in the tap. Grab a snippet and drop it into any README.</p>
    <div class="stats">
      <div class="stat"><div class="n">${total_dl}</div><div class="l">Install downloads</div></div>
      <div class="stat"><div class="n">${total_pkgs}</div><div class="l">Packages</div></div>
    </div>
    <div class="tap">
      <span class="tap-label">Tap-wide</span>
      <img src="https://img.shields.io/endpoint?url=${tap_enc}&amp;style=flat-square&amp;logo=homebrew" alt="tap total downloads">
      <details class="embed">
        <summary>Markdown</summary>
        <div class="code-wrap"><pre><code>[![homebrew tap](https://img.shields.io/endpoint?url=${tap_enc}&amp;style=flat-square&amp;logo=homebrew)](${tap_url})</code></pre>
        <button class="copy" type="button" aria-label="Copy tap badge Markdown"><span class="copy-label">Copy</span></button></div>
      </details>
    </div>
  </header>

  <main>
    <p class="section">Packages <b>(${total_pkgs})</b></p>
${cards}
  </main>

  <footer class="footer">
    Updated ${gen_date} &middot; counts from GitHub release assets (<code>.dmg</code> / <code>.tar.gz</code>) &middot;
    rendered via <a href="https://shields.io">shields.io</a> from JSON hosted here.
  </footer>
</div>
<script>
  document.querySelectorAll(".copy").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var code = btn.parentElement.querySelector("code");
      navigator.clipboard.writeText(code.innerText).then(function () {
        var label = btn.querySelector(".copy-label");
        var prev = label.textContent;
        label.textContent = "Copied";
        btn.setAttribute("data-copied", "true");
        setTimeout(function () { label.textContent = prev; btn.removeAttribute("data-copied"); }, 1400);
      });
    });
  });
</script>
</body>
</html>
HTML

echo "Built site in '$out' (base: $BASE_URL)" >&2
