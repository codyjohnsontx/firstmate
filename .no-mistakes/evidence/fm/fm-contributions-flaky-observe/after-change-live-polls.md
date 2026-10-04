# AFTER (a586341): live polls of https://github.com/kunchenguid/firstmate/pull/5717 via real gh, fresh lab record

## S1/S2 the reported flip-flop sequence

### [after] poll: healthy PR, network up
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:23Z","error":null,"failures":0,"state":"open","head":"56189804"}

### [after] poll: one answered failure (GitHub HTTP 401) on every read this poll
gh calls: 2 ( 2 badtoken )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:26Z","error":"forge observation unavailable","failures":1,"state":"open","head":"56189804"}

### [after] poll: healthy again
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:27Z","error":null,"failures":0,"state":"open","head":"56189804"}

### [after] poll: host has no network (dark wake): every read gets dial tcp refused
gh calls: 2 ( 2 nonet )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:27Z","error":null,"failures":0,"state":"open","head":"56189804"}

### [after] poll: healthy again
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:29Z","error":null,"failures":0,"state":"open","head":"56189804"}

## S3 no network persists across polls (adversarial: never wakes, record untouched)

### [after] poll: no network #1
gh calls: 2 ( 2 nonet )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:29Z","error":null,"failures":0,"state":"open","head":"56189804"}

### [after] poll: no network #2
gh calls: 2 ( 2 nonet )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:29Z","error":null,"failures":0,"state":"open","head":"56189804"}

### [after] poll: no network #3
gh calls: 2 ( 2 nonet )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:29Z","error":null,"failures":0,"state":"open","head":"56189804"}

## S4 transient failure re-read within the same poll

### [after] poll: first read dial-refused, re-read succeeds
gh calls: 9 ( 1 nonet 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:33Z","error":null,"failures":0,"state":"open","head":"56189804"}

### [after] poll: first read HTTP 401, re-read succeeds
gh calls: 9 ( 1 badtoken 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:36Z","error":null,"failures":0,"state":"open","head":"56189804"}

## S5 persistent answered failure still wakes exactly once, on the 2nd consecutive failure

### [after] poll: HTTP 401 #1
gh calls: 2 ( 2 badtoken )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:38Z","error":"forge observation unavailable","failures":1,"state":"open","head":"56189804"}

### [after] poll: HTTP 401 #2
gh calls: 2 ( 2 badtoken )
exit: 0
stdout (wake output): contributions: observation unavailable for https://github.com/kunchenguid/firstmate/pull/5717
record: {"checked_at":"2026-10-04T09:23:39Z","error":"forge observation unavailable","failures":2,"state":"open","head":"56189804"}

### [after] poll: HTTP 401 #3
gh calls: 2 ( 2 badtoken )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:40Z","error":"forge observation unavailable","failures":3,"state":"open","head":"56189804"}

### [after] poll: recovered
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:41Z","error":null,"failures":0,"state":"open","head":"56189804"}

## S6 adversarial: a miss between answered failures neither resets nor hides the episode

### [after] poll: HTTP 401 #1
gh calls: 2 ( 2 badtoken )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:43Z","error":"forge observation unavailable","failures":1,"state":"open","head":"56189804"}

### [after] poll: no network (miss)
gh calls: 2 ( 2 nonet )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:43Z","error":"forge observation unavailable","failures":1,"state":"open","head":"56189804"}

### [after] poll: HTTP 401 #2 -> must wake
gh calls: 2 ( 2 badtoken )
exit: 0
stdout (wake output): contributions: observation unavailable for https://github.com/kunchenguid/firstmate/pull/5717
record: {"checked_at":"2026-10-04T09:23:44Z","error":"forge observation unavailable","failures":2,"state":"open","head":"56189804"}

### [after] poll: recovered
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:45Z","error":null,"failures":0,"state":"open","head":"56189804"}

## S7 legacy record written by the old code (error set, no failures field)
seeded legacy record: {"error":"forge observation unavailable or changed during read","failures":null}

### [after] poll: HTTP 401 against a legacy already-announced error -> must stay quiet
gh calls: 2 ( 2 badtoken )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:48Z","error":"forge observation unavailable","failures":3,"state":"open","head":"56189804"}

### [after] poll: recovered
gh calls: 8 ( 8 ok )
exit: 0
stdout (wake output): <none>
record: {"checked_at":"2026-10-04T09:23:48Z","error":null,"failures":0,"state":"open","head":"56189804"}
