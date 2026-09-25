#!/usr/bin/env bash
# Live driver part 2: forge answers with a failure (HTTP 404, auth refusal), plus base-commit repro.
set -u
WT=$1 LAB=$2 BASE=$3
GONE=https://github.com/Moonfin-Client/Moonfin-Core/pull/99999999
URL=https://github.com/Moonfin-Client/Moonfin-Core/pull/1621
clean() { env -u NO_MISTAKES_GATE -u FM_GATE_REFUSE_BYPASS -u FM_ROOT_OVERRIDE -u FM_STATE_OVERRIDE \
  -u FM_DATA_OVERRIDE -u FM_CONFIG_OVERRIDE -u FM_PROJECTS_OVERRIDE FM_HOME="$LAB" "$@"; }
poll() { local root=$1 label=$2; shift 2; echo "---- poll: $label"; local out rc=0
  out=$(clean "$@" "$root/bin/fm-contributions.sh" poll 2>&1) || rc=$?
  echo "exit=$rc"; echo "stdout (wake lines): ${out:-<none>}"; }
show() { jq -c --arg u "$2" '.records[] | select(.url==$u) | {url,checked_at,error,failures,missed_at}' "$LAB/data/$1/contributions.json"; }
T0=$(date -u +%s); iso() { date -u -r $((T0 + $1)) +%Y-%m-%dT%H:%M:%SZ; }
NOPROXY=(env -u NO_PROXY -u no_proxy HTTPS_PROXY=http://127.0.0.1:1 https_proxy=http://127.0.0.1:1)

echo "== S5 forge answers HTTP 404 on every poll (nonexistent PR): wakes once, on the 2nd consecutive failure"
mkdir -p "$LAB/data/gone"
printf -- '- [ ] gone - Persistent forge failure %s (repo: moonfin) (kind: ship)\n' "$GONE" >> "$LAB/data/backlog.md"
for i in 1 2 3; do poll "$WT" "404 #$i" FM_CONTRIBUTIONS_NOW="$(iso $((i*600)))"; show gone $GONE; show moonfin $URL; done

echo; echo "== S6 authentication refusal (no gh login) is unavailable, not a miss"
GHH=$(mktemp -d); mkdir -p "$GHH"
poll "$WT" "no-auth #1" env -u GITHUB_TOKEN -u GH_TOKEN HOME="$GHH" GH_CONFIG_DIR="$GHH" FM_CONTRIBUTIONS_NOW="$(iso 2400)"
show moonfin $URL
rm -rf "$GHH"
echo "(restore with a good poll)"
poll "$WT" "good" FM_CONTRIBUTIONS_NOW="$(iso 3000)"; show moonfin $URL

echo; echo "== S7 baseline repro: base commit 1a814e4 against the same no-network condition"
sed -i '' '/pull\/99999999/d' "$LAB/data/backlog.md"; rm -rf "$LAB/data/gone"
poll "$BASE" "BASE no-network" "${NOPROXY[@]}" FM_CONTRIBUTIONS_NOW="$(iso 3600)"
jq -c --arg u "$URL" '.records[] | select(.url==$u) | {url,checked_at,error}' "$LAB/data/moonfin/contributions.json"
poll "$BASE" "BASE network back" FM_CONTRIBUTIONS_NOW="$(iso 4200)"
poll "$BASE" "BASE no-network again" "${NOPROXY[@]}" FM_CONTRIBUTIONS_NOW="$(iso 4800)"
