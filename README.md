# Bleach: NeXt

A modern, ground-up reimagining of the classic BYOND game **Bleach: Souls of Chaos**, written in Dream Maker (DM) and designed to grow alongside the *Bleach* anime through large, story-driven expansions.

> **Status:** Early development / active work in progress
> **Language:** Dream Maker (BYOND) · **Platform:** BYOND 5xx.xxxx *(update to your version)*

---

## About

Bleach: NeXt began as a branch of the old *Souls of Chaos* source, but the codebase has since been rebuilt from scratch. The goal is not to patch legacy code, but to replace it with a cleaner, more maintainable architecture while keeping the spirit of the original game.

This is a solo project. It is published as a showcase of my work with DM and game systems design.

## Goals

- **Modern codebase:** a clean, consistent, and readable rewrite instead of inherited legacy code
- **Modular systems:** features built as self-contained systems that are easy to extend
- **Anime-driven expansions:** content released in large arcs that follow the *Bleach* storyline
- **Performance-minded design:** avoid the common pitfalls of older BYOND sources

## Features

*(Trim or expand this list to match what is actually implemented.)*

- **Client click handling:** clicks pass through a type-validation layer (`/turf`, `/mob`, `/obj`, etc.) before any interaction is created, so the world only reacts to valid targets
- **Spell and ability system:** abilities are driven by the click system, creating interactions between the player's mob and the world
- **Aura system:** equipment (`/item`) can grant auras through a `grant_auras` list, and mobs apply or remove them with `apply_aura()` / `remove_aura()`
- *[Add: combat, progression, races/factions, zanpakuto, etc.]*

## Project Structure

*(Adjust to your real layout.)*

```
Bleach-NeXt/
├── code/
│   ├── _defines/       # Global macros and constants
│   ├── client/         # Client-side input and click handling
│   ├── mobs/           # Mob types and behavior
│   ├── items/          # Equipment and items
│   ├── spells/         # Abilities and interactions
│   └── ...
├── icons/              # Sprites and icon files
├── maps/               # Map files (.dmm)
├── Bleach-NeXt.dme     # Main environment file
└── README.md
```

## Getting Started

### Requirements

- [BYOND](https://www.byond.com/download/) (Dream Maker and Dream Seeker)

### Running locally

1. Clone the repository:
   ```
   git clone https://github.com/<your-username>/<repo-name>.git
   ```
2. Open `Bleach-NeXt.dme` in **Dream Maker**.
3. Compile with **Build → Compile** (or press `F5`).
4. Run with **Build → Run** to launch the game in **Dream Seeker**.

## Roadmap

- [x] Core click and interaction framework
- [x] Aura and equipment foundation
- [ ] *[Next system]*
- [ ] *[Saga 1 content]*
- [ ] *[Later arcs]*

## About This Repository

This project is developed solo and is not open to outside contributions. Feel free to browse the code, and if you have feedback or questions, reach out via GitHub issues or the contact below.

## Credits & Disclaimer

- Inspired by and branched from **Bleach: Souls of Chaos**, with thanks to the original creators and community.
- *Bleach* is created by **Tite Kubo**. This is an unofficial, non-commercial fan project and is not affiliated with or endorsed by Tite Kubo, Shueisha, or Studio Pierrot.
- Built with [BYOND](https://www.byond.com/).

## Contact

**[Your Name]** · [GitHub](https://github.com/<your-username>) · [LinkedIn](https://linkedin.com/in/<your-profile>) · [Email](mailto:you@example.com)
