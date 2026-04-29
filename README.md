# [🔧 Hard hat required: Under constuction 🔧] accountabili-buddy [🔧 Version 1.1 updates incoming 🔧]

```
૮(„• ⌔ •„)ა⛑
 Hi, I'm abuddy
```

> *"It looks like you're trying to focus. Can I help with that?"*
> *(yes, but make it self care)*

**accountabili-buddy** (abuddy) is a terminal-based Pomodoro-style focus timer with built-in self care breaks, session logging, and a wins tracker — because you deserve more than a countdown and a beep.

A standard Pomodoro timer tells you when to work and when to stop. Abuddy does that, and also reminds you to drink water, logs what you accomplished, asks how it went, and keeps a running file of your wins so you start every session knowing you've done hard things before.

---
## Learn More

To read more about why I developed this and the process, you can visit my blog at this post: [404: Not Found, still writing the thing]

---

## Requirements

- **Linux** (Ubuntu 20.04+ recommended)
- **Bash** 4.0 or later
- **GNU date** (standard on Linux — used for timestamp math)

> **WSL users:** If you're on Windows with WSL (Windows Subsystem for Linux) installed, abuddy should work fine from your WSL terminal.
>
> **macOS:** Not currently supported — macOS uses BSD date, which handles time arithmetic differently. macOS support is on the wishlist for a future version.

---

## Installation

**1. Clone or download the repo**

```bash
git clone https://github.com/sionalarsen-sys/accountabili-buddy.git
cd accountabili-buddy
```

Or download the ZIP from GitHub and unzip it. Either way, make sure `abuddy.sh` and `install.sh` are in the same folder — the installer needs both files present to work.

**2. Run the installer**

```bash
chmod 700 install.sh
bash install.sh
```

The installer will walk you through everything:
- Choosing where your files live (default: `~/.abuddy/`)
- Creating your list files with starter content
- Optionally adding an `abuddy` shortcut command
- A demo walkthrough so you know what to expect before your first real session

> **Hidden directories on Linux:** folders starting with a dot (`.abuddy`) don't show up in a normal `ls` listing — this is intentional and keeps your home folder tidy. Use `ls -a` to see hidden items, or `ls -a ~/.abuddy/` to list your abuddy files directly.

**3. Start a session**

```bash
abuddy
```

Or if you skipped the alias step:

```bash
bash ~/.abuddy/abuddy.sh
```

---

## Customizing Your Lists

Your list files live in `~/.abuddy/` (or wherever you installed). Each file is plain text — one entry per line. Open any of them in a text editor and make them yours.

| File | Used for |
|---|---|
| `exercises.txt` | Movement suggestions shown during breaks |
| `nudges.txt` | Self care reminders shown during breaks |
| `goals.txt` | Pulled randomly if you skip the goal prompt at setup |
| `reflections.txt` | Random reflection question at session end |
| `wins.txt` | One past win shown at the start of each session |

The `examples/` folder in this repo has the starter entries so you can see the format and get ideas for what to add or change.

---

## Changing Your Defaults

Your config file lives at `~/.abuddy/abuddy.cfg`. Open it in any text editor to change your default session settings:

```bash
DEFAULT_WORK=25       # work block length in minutes
DEFAULT_BREAK=5       # break length in minutes
DEFAULT_SESSIONS=4    # number of sessions
```

These values pre-fill the setup prompts when you press Enter without typing anything. You can still override them at the start of any session — the config just sets your personal starting point.

---

## Bell Not Working?

Abuddy rings a terminal bell at transitions between work and break blocks. Whether you hear it depends on your terminal's settings.

**VS Code terminal**
The bell is on auto by default which does not seem to make sound. To enable it:
- Open Settings → Features → Accessibility Signals → Scroll to near the bottom →
- Signals: Terminal Bell → sound: on

**Windows Terminal (via PowerShell SSH)**
Usually works without changes. If not, check Terminal Settings → your profile → Bell notification style.
To customize the sound:
- Open Settings → Profiles on the side bar and Windows Power Shell → Bell sound
- Above you can change the Bell notification style, for sound it must be on audible
- Bell sound plays the default system sound, but you can hit + Add Sound and point it to any .wav 
- If you have multiple, it selects one at random every time ^.^

**Codespaces**
For mine, it's the same as VSCode. And it all runs!

**Other terminals**
Look for a bell or sound option in your terminal's preferences - I don't have experience here 

**If you can't get the bell working,** everything else works fine without it — you just won't get an audio nudge at transitions. The visual output makes it clear when blocks end regardless. I tried to make transitions color unique.

**Future Development**
I would love to look into more ways to get notifications from the script in future versions.

---

## Session Log

Every session is appended to `~/.abuddy/abuddy.log.md` in Markdown format, recording your start and finish times, all your goals (including mid-session changes), your reflection, and your win if you logged one.

The file is plain Markdown — readable in any text editor, and compatible with note-taking apps like Obsidian if you want to pull it into a vault.

---

## What's Next

This is an early version and there's room to grow. Things on the wishlist:

- More defaults in the text documents to flesh out the script more - if you feel like sending suggestions, I'd love to see them! `૮(♥ ⌔ ♥)ა`
- macOS support (BSD date compatibility)
- A proper mascot (`૮(„• ⌔ •„)ა` is doing their best)
- Configurable color themes (I considered shipping a more monochrome version but this is my script, I do what I want)
- Further notifications
- Anything else the community suggests

If you have ideas or found a bug, feel free to open an issue or reach out directly. This is a work in progress and feedback is genuinely welcome.

---

## A Note on Inclusivity

The default content was written to be as inclusive as we could make it — low impact movement that tries not to assume your ability, neutral language (abuddy goes by they/them btw), no assumptions. If something misses the mark or could do better, feedback is always welcome. And of course, the lists are yours to make your own - please don't let them 

---

## License

MIT — do what you want with it, just don't remove the credit.
See [LICENSE](LICENSE) for the full text.

---

## Author

- Siona Larsen
- https://www.linkedin.com/in/sionalarsen/
- Blog: https://sionalarsen-sys.github.io/

P.S. - While a proper mascot is in the wishlist, I created abuddy as an emoticon to try to invoke a penguin. Think of them as Tux's littlest sibling ^.^
