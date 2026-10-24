# Backup and retention — 24 October 2026

Public source/web recovery is verified in [the preview.2 receipt](preview2-remote-recovery.json). A separate private checkpoint preserves 31 reviewed evidence/code files: original harnesses, build/configuration provenance, assisted reviews, result summaries and two synthetic app licence captures. All six checkpoint assets (including an append-only metadata correction) were downloaded and verified; every restored file matched its original. The archive itself remains unchanged. This is selected evidence recovery, not full workspace recovery.

The private archive excludes the unnecessary token-bearing failed-attempt JSON. Its exact selection and archive manifest already reflected that exclusion; a generated omission-map label was stale and received a separately hashed correction. Raw CI/Xcode/verbose host logs, xcresults, the compiled experiment, reference captures and unreviewed originals are outside this checkpoint and remain local. Older unsigned wording in dated SPM notes is superseded by actual ad-hoc/no-developer-identity inspection.

After verified remote recovery and byte comparison against retained originals, only four exclusive temporary verification copies were removed. [Removal receipt](cleanup-verified-copies-2026-10-24.json).

| Workspace-relative path | Files | Logical bytes removed |
| --- | ---: | ---: |
| `work/recovered-preview2` | 8 | 15675561 |
| `work/recovered-private-backup24-final` | 6 | 216812 |
| `work/recovered-private-backup24` | 4 | 215955 |
| `work/restored-private-backup24` | 31 | 320873 |

Total logical bytes removed: 16429201; allocated file bytes: 16543744. Actual physical free-space change is not attributed because APFS snapshots/clones and concurrent peer work can affect it. Original source, output archives, unique logs, screenshots, SPM bundle/configuration and SDK remain intact for the pending native check. No unrelated app, browser state, system setting or source checkout was removed.
