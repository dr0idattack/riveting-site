#!/bin/sh
# Content gate for the Riveting website.
# Usage: verify.sh          check required content in the local pages
#        verify.sh --live   also fetch the deployed URLs (after Pages is on)
set -euo pipefail
cd "$(dirname "$0")"

BASE="${WEBSITE_BASE:-https://dr0idattack.github.io/riveting-site}"
fail=0

check() { # file regex label
  if grep -qiE "$2" "$1"; then
    echo "ok   $1: $3"
  else
    echo "FAIL $1: $3 (pattern: $2)"
    fail=1
  fi
}

# Required structure
for f in index.html support.html privacy.html styles.css; do
  if [ ! -f "$f" ]; then echo "FAIL missing $f"; fail=1; fi
done

check index.html    '<h1>Riveting</h1>'        'app name as App Store title'
check index.html    'support\.html'            'link to support page'
check index.html    'privacy\.html'            'link to privacy page'
check index.html    'jpthomp137@gmail\.com'    'publisher contact'

# App Review Guideline 1.5: contact info visible at the top of the support page
# (checked as content above the first FAQ heading)
head -c "$(grep -b -m1 '<h2>Questions' support.html | cut -d: -f1)" support.html \
  | grep -qi 'mailto:jpthomp137@gmail\.com' \
  && echo "ok   support.html: contact email above the FAQ" \
  || { echo "FAIL support.html: contact email above the FAQ"; fail=1; }

for topic in 'restore' 'refund' 'saves' 'bug'; do
  check support.html "$topic" "support topic: $topic"
done

# Guideline 5.1.1: policy must state collection, use and retention/deletion
check privacy.html  'last updated'             'policy has a dated version'
for topic in 'collect' 'purchase' 'delete' 'retention|rights'; do
  check privacy.html "$topic" "policy topic: $topic"
done

# Player-facing text never says "peg" outside the code-name URL
check support.html  'mailto:'                  'mailto link present'
if grep -riE '\bpegs?\b' *.html; then
  echo "FAIL player-facing text says peg"
  fail=1
else
  echo "ok   player-facing text uses rivet wording only"
fi

if [ "${1:-}" = "--live" ]; then
  for page in '' 'support.html' 'privacy.html'; do
    if curl -fsSL -o /dev/null "$BASE/${page}"; then
      echo "ok   live $BASE/$page"
    else
      echo "FAIL live $BASE/$page"
      fail=1
    fi
  done
fi

exit "$fail"
