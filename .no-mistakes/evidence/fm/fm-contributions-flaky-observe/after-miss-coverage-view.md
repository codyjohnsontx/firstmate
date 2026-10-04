# S8 a persistently unanswered read stays quiet but surfaces in the bearings coverage view
seeded: last good observation 2026-10-03T00:00:00Z (over a day ago)

### [after] poll: no network while the record is stale
gh calls: 2 ( 2 nonet )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-03T00:00:00Z","error":null,"failures":0,"state":"open","head":"56189804"}

bearings --json (contribution-related fields):
[
  {
    "path": "contributions.scope",
    "value": "owned contributions per home"
  }
]
{
  "scope": "owned contributions per home",
  "known": 1,
  "checked": 0,
  "counts": {
    "captain": 0,
    "fleet": 1,
    "maintainer": 0,
    "nobody": 0
  },
  "complete": false,
  "proven_clear": false,
  "unmeasured_homes": 0,
  "unreadable_records": 0,
  "unmeasured": 0,
  "stale_verdicts": 0,
  "missing_verdicts": 0,
  "captain_omitted": 0,
  "captain": []
}

fm-contributions.sh snapshot --all row (the projection bearings counts as fleet work):
{"url":"https://github.com/kunchenguid/firstmate/pull/5717","actor":"fleet","reason":"contribution not recently checked","checked_at":"2026-10-03T00:00:00Z"}
