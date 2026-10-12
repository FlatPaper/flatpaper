# Long-form docs

Written for Notion. Adapt it for Google Drive and Docs, Confluence, Coda, and others like them. Read each tool's schema before calling it. Tool names differ by connector.

## What it holds

- PRDs, technical specs, and RFCs.
- Architecture decision records.
- Design review and meeting notes.
- Postmortems.
- Runbooks that explain defensive code.
- Strategy docs that set priorities.

A significant feature usually has a doc. The why often lives here in long form before it becomes code.

## How to search

1. **Search by keyword.** Feature name, key symbols, the PR author's name, error strings, user-facing terms. Bound by date when you know the ship date.
2. **Fetch full pages.** Read the whole page, not the search preview. The reason is often mid-document.
3. **Follow child pages and backlinks.** Alternatives considered, appendices, and implementation notes often sit on sub-pages.
4. **Check databases and meeting notes.** Notion databases and meeting-note collections can hold the meeting where the call was made.
5. **Look in the author's space.** A personal notebook may hold the thinking that came before the code.

## Good evidence

- A "Problem" or "Motivation" section that matches the code's purpose.
- An "Alternatives considered" or "Rejected approaches" section.
- A postmortem that names the target code as the fix.
- Meeting notes recording "we decided X because Y" near the PR's date.
- A filled-out ADR: status, context, decision, consequences.

## Pitfalls

- **Stale specs.** A spec written before the code may describe a plan that changed. Note where doc and code differ.
- **Template filler.** Look for specifics.
- **Unlinked docs.** The best doc may be linked from nowhere. Broad keyword searches find it.
- **Several drafts.** Find the final or most recently updated one. Check dates.
- **No access.** A page you can't open is a gap.

## What to return

Per doc: title, URL, authors, last-updated date, draft or final, the motivation quoted verbatim with its section, and linked pages worth citing.
