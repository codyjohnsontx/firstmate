#!/usr/bin/env bash
# Live driver: real gh against real GitHub, disposable lab FM_HOME.
set -u
WT=$1 LAB=$2
URL=https://github.com/Moonfin-Client/Moonfin-Core/pull/1621
REC="$LAB/data/moonfin/contributions.json"
clean() { env -u NO_MISTAKES_GATE -u FM_GATE_REFUSE_BYPASS -u FM_ROOT_OVERRIDE -u FM_STATE_OVERRIDE \
  -u FM_DATA_OVERRIDE -u FM_CONFIG_OVERRIDE -u FM_PROJECTS_OVERRIDE FM_HOME="$LAB" "$@"; }
poll() { # label [env...]
  local label=$1; shift
  echo "---- poll: $label"
  local out rc=0
  out=$(clean "$@" "$WT/bin/fm-contributions.sh" poll 2>&1) || rc=$?
  echo "exit=$rc"
  echo "stdout (wake lines): ${out:-<none>}"
}
show() { # task
  jq -c --arg u "$2" '.records[] | select(.url==$u) | {url,checked_at,error,failures,missed_at,state:.observation.state,head:.observation.head}' "$LAB/data/$1/contributions.json"
}
NOPROXY=(env -u NO_PROXY -u no_proxy HTTPS_PROXY=http://127.0.0.1:1 https_proxy=http://127.0.0.1:1)
T0=$(date -u +%s)
iso() { date -u -r $((T0 + $1)) +%Y-%m-%dT%H:%M:%SZ; }

echo "== S1 healthy PR: real gh, network up"
poll "healthy" FM_CONTRIBUTIONS_NOW="$(iso 0)"
show moonfin $URL

echo; echo "== S2 host has no network (refused proxy) - three consecutive polls"
for i in 1 2 3; do
  poll "no-network #$i" "${NOPROXY[@]}" FM_CONTRIBUTIONS_NOW="$(iso $((i*600)))"
  show moonfin $URL
done

echo; echo "== S3 coverage view after a long miss streak (clock +3600s, max age 900)"
clean FM_CONTRIBUTIONS_NOW="$(iso 3600)" "$WT/bin/fm-fleet-snapshot.sh" --contribution-input > "$LAB/input.json"
clean FM_CONTRIBUTIONS_NOW="$(iso 3600)" "$WT/bin/fm-contributions.sh" snapshot "$LAB/input.json" --all \
  | jq -c '{known,checked:(.checked // .measured // null),fleet:(.fleet // null),rows:[.rows[] | {url,fresh,actor,reason}]}'

echo; echo "== S4 the reported flip pattern: miss, success, miss, success"
poll "no-network" "${NOPROXY[@]}" FM_CONTRIBUTIONS_NOW="$(iso 4200)"; show moonfin $URL
poll "network back" FM_CONTRIBUTIONS_NOW="$(iso 4800)"; show moonfin $URL
poll "no-network" "${NOPROXY[@]}" FM_CONTRIBUTIONS_NOW="$(iso 5400)"; show moonfin $URL
poll "network back" FM_CONTRIBUTIONS_NOW="$(iso 6000)"; show moonfin $URL
