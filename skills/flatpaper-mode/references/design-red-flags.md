# Design red flags

Screen every sketched design against this list. A red flag is a reason to revise or reject the shape.

## Shallow module

The interface is large and hides little. Callers call several methods to finish one operation, or options expose internal stages. Prefer a small interface backed by real behavior. A deep call chain is not a deep module.

## Information leakage

Two modules depend on the same internal decision, so changing it means coordinated edits. Parse wire and storage types into domain types at the boundary. Don't re-export them.

## Temporal decomposition

Modules follow execution order (load, validate, transform, save) instead of the knowledge they own, so one representation repeats across boundaries. Group code by what it knows.

## Pass-through method

A method forwards the same arguments to another with the same shape. Remove it unless it adds policy or adaptation.

## Split ownership

More than one module writes the same state or keeps its own copy. Give each piece of state one owner. Others read it or ask the owner.

## Two ways to do one task

Callers copy whichever way they find first, so both keep growing. Keep one way and delete the other in the same change.

## Importable internals

If a caller can import internals, it will, and they become the interface. Make them unreachable so an outside import fails the build.

## Hand-synced list

Several places list the same items and each must be edited by hand. Keep one list and derive the rest. If one can't be derived, make the build fail when they disagree.
