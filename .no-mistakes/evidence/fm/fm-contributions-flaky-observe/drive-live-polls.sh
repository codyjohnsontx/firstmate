#!/usr/bin/env bash
# Live driver: runs bin/fm-contributions.sh poll (real gh, real GitHub) in a
# disposable lab FM_HOME for a given code tree, under per-poll network
# conditions. Usage: drive-live-polls.sh <lab> <bin-dir> <label>
set -u
LAB=$1 BIN=$2 LABEL=$3
REC=$LAB/data/flaky-pr/contributions.json
P() { env -u NO_MISTAKES_GATE -u FM_GATE_REFUSE_BYPASS -u FM_ROOT_OVERRIDE -u FM_STATE_OVERRIDE \
  -u FM_DATA_OVERRIDE -u FM_CONFIG_OVERRIDE -u FM_PROJECTS_OVERRIDE \
  PATH="$LAB/shim:$PATH" GH_LOG="$LAB/gh.log" GH_MODES="$LAB/modes" FM_HOME="$LAB" "$@"; }
poll() { # description, then the poll's per-call modes (one per gh call; empty = all ok), or ALL=<mode>
  local desc=$1; shift
  : > "$LAB/modes"; : > "$LAB/gh.log"
  local all=
  case "${1:-}" in ALL=*) all=${1#ALL=}; shift ;; esac
  for m in "$@"; do printf '%s\n' "$m" >> "$LAB/modes"; done
  local out rc=0
  out=$(GH_ALL=$all P "$BIN/fm-contributions.sh" poll 2>&1) || rc=$?
  printf '\n### [%s] poll: %s\n' "$LABEL" "$desc"
  printf 'gh calls: %s (' "$(wc -l < "$LAB/gh.log" | tr -d ' ')"; cut -d' ' -f1 "$LAB/gh.log" | sort | uniq -c | tr -s ' \n' ' '; printf ')\n'
  printf 'exit: %s\nstdout (wake output): %s\n' "$rc" "${out:-<none>}"
  printf 'record: %s\n' "$(jq -c '.records[0] | {checked_at,error,failures,state:.observation.state,head:(.observation.head[0:8])}' "$REC")"
}
