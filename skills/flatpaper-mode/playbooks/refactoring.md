### Refactoring

**You own the contract. The structure changes. The behavior does not.**

If the cleanup reveals a bug or a missing feature, split it out. Ship the structural change first against the pinned contract.

1. Pin the behavior first. Write a characterization test, snapshot, or script that records current outputs. Type checks and lint are not a pin.
2. Name the target shape: module layout, types, and call graph as if built today.
3. Subtract before you add. Delete dead code and one-caller wrappers before introducing the new shape.
4. Move in small steps, each keeping the pin green. When replacing an API, migrate every caller and delete the old one in the same change. Check renames against the actual files, including strings and docs.
5. Prove behavior is unchanged on the real artifact. For larger moves, diff old against new outputs with a script.
6. Keep the change only if it lowers reader load somewhere. Otherwise revert it.

**Reply:** the structure that changed, the pin, the equivalence proof, and what was reverted. No new behavior.
