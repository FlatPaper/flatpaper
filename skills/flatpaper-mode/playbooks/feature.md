### Feature

**You own the design. Plan, review, verify.**

1. Trace the affected code before designing.
2. Pin what must not change (existing output, existing commands) and record it before editing.
3. Name the data shape first, and pick its organizing structure (model the domain).
4. If the change crosses module boundaries or has several valid shapes, sketch two designs before committing. Write how the caller uses each one first. Judge the sketches against `../references/design-red-flags.md`. If running something would settle the choice, prototype it.
5. Implement in small units, each ending in a check (sequence verifiable units).
6. Verify on the real surface: the new behavior works, and the pinned behavior is unchanged.
7. If the change added, removed, or rewired something the architecture page shows, run the Architecture page playbook in update mode and include it in the same PR.
8. Hand the diff to a fresh subagent for review. It did not write the change.

**Reply:** what you built, what you chose and why, the proof for both new and unchanged behavior, and open decisions. Tables for design alternatives.
