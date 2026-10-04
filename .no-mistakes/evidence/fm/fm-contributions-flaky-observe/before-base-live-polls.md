# BEFORE (base fede619): live polls of https://github.com/kunchenguid/firstmate/pull/5717 via real gh, fresh lab record

### [before] poll: healthy PR, network up
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:04Z","error":null,"failures":null,"state":"open","head":"56189804"}

### [before] poll: one answered failure (GitHub HTTP 401) on every read this poll
gh calls: 1 ( 1 badtoken )
exit: 0
stdout (wake output): contributions: observation unavailable for https://github.com/kunchenguid/firstmate/pull/5717
record: {"checked_at":"2026-10-04T09:23:07Z","error":"forge observation unavailable or changed during read","failures":null,"state":"open","head":"56189804"}

### [before] poll: healthy again
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:07Z","error":null,"failures":null,"state":"open","head":"56189804"}

### [before] poll: host has no network (dark wake): every read gets dial tcp refused
gh calls: 1 ( 1 nonet )
exit: 0
stdout (wake output): contributions: observation unavailable for https://github.com/kunchenguid/firstmate/pull/5717
record: {"checked_at":"2026-10-04T09:23:10Z","error":"forge observation unavailable or changed during read","failures":null,"state":"open","head":"56189804"}

### [before] poll: healthy again
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:10Z","error":null,"failures":null,"state":"open","head":"56189804"}
