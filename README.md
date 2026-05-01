# UPDATE 5/1/2026 accountabili-buddy v1.1.1

```
૮(„• ⌔ •„)ა⛑
 Hi, I'm abuddy v1.1.1
```

> *"It looks like you're trying to focus. Can I help with that?"*
> *(yes, but make it self care)*

**accountabili-buddy** (abuddy) is a terminal-based Pomodoro-style focus timer with built-in self care breaks, session logging, and a wins tracker — because you deserve more than a countdown and a beep.

A standard Pomodoro timer tells you when to work and when to stop. Abuddy does that, and also reminds you to drink water, logs what you accomplished, asks how it went, and keeps a running file of your wins so you start every session knowing you've done hard things before.

---
## Learn More

To read more about why I developed this and the process, you can visit my blog at this post: [Dev Log: I Made a Little Guy - Abuddy](https://sionalarsen-sys.github.io/posts/abuddydev/)
(Note: it primarily focuses on version 1.0 but does lay out some details from the v1.1 update that is live)

---

## tl;dr

Abuddy v1.1.1 is still the original out of the box abuddy but with some optional features and a much slicker configuration set up. Run `install.sh` if you're brand new to abuddy or `update.sh` if you already have abuddy and want to new features.

Abuddy now offers a reward system, a break reflection to input new items into the nudges doc, goal completion tracking, a big break after a reflection, and more. Check out the changelog for the breakdown.

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
| `auto-nudges.txt` | Self care reminders shown during breaks |
| `goals.txt` | Pulled randomly if you skip the goal prompt at setup |
| `session-q.txt` (previously `reflections.txt`) | Random reflection question at session end |
| `auto-wins.txt` | One past win shown at the start of each session |
| NEW `break-q.txt` | Questions for end of break to help build the nudges list |
| NEW `auto-rewards.txt` | List of things that you can reward/treat yourself with at break times |

UPDATE: Standardized `txt` file format. `auto-*.txt` are files that abuddy will write to during a session (if you want them to). `*-q.txt` are files holding questions for reflection. All other `*.txt` files remain the same

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

## NEW `update.sh`

Already have abuddy installed but want the new updates? Or want to change some of your files and settings in the config file without manually mucking about in the guts?

Introducing `update.sh`

This script will check to see if you already have a config file -- if you don't, run `install.sh` -- and then double check the version. If you're all up to date, nothing is changed or added but you can continue on to changing your configuration on other settings.

`install.sh` will still allow you to do a full fresh install if you want (and check the demo for the new features), but I still recommend backing up any logs you want to keep.

---

## NEW Config Keys and Features

The previous session settings are still there but now you have so many more options to make abuddy right for you!

`BIG_BREAK` is a default 20 minute break after your reflection
`FOCUS_NAME` Name the working/studying period whatever your heart desires. Default is Focus Round.
`ALERT_MODE` **Not Fully Operational** This will let you change between sound, flashing, both, or silent

```bash
REWARDS_ENABLED
COMPLETION_TRACKING
BUFFER_REVIEW
BREAK_REFLECTION
```

These settings als you to set them as ask at each session, always on, or off so you don't see them at all in your sessions.

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

Every session is appended to `~/.abuddy/abuddy.log.md` in Markdown format — readable in any text editor, and compatible with note-taking apps like Obsidian if you want to pull it into a vault.

NEW

The original Start, finish, goals, reflection, and win are still included in the log but now there's more.

- Completion marking on goals with time stamp 
- Final reward
- The amount of time between hitting the end of a round/break and before you hit enter to start the next (buffer time)
- Answers to your break questions

Most of these are togglable/optional - check your configurations

---

## Changelog

### v1.1.1
- Refactored reward, goal completion, and break reflection into functions
- Timestamp displays now include seconds
- Focus label now fully customizable via FOCUS_NAME
- Final goal correctly asking if you completed it
- Updated default break-q to be more useful for generating content for auto-nudges

### v1.1.0
- Added reward system to motivate you to your break
- Added goal completion tag to mark in the log (fix for final goal in v1.1.1)
- Added a buffer timer tracker to count time when rounds and breaks aren't active
- Added end of break prompts to generate material for the nudges list
- Added an optional end of session big break of 20 minutes after the reflection
- Reworked configuration set up to allow for setting default time of big break, change the name of focus rounds, and toggles on added functions

---

## Roadmap

Here's a preview of what's in the works for V1.2:

- Add a demo mode
- Mid-round reward reminder
- Big reward list for your big break
- Dynamic focus labels so you can choose to randomize every session

---

## What's Next

This is an early version and there's room to grow. Things on the wishlist:

- More defaults in the text documents to flesh out the script more - if you feel like sending suggestions, I'd love to see them! `૮(♥ ⌔ ♥)ა`
- macOS support (BSD date compatibility)
- A proper mascot (`૮(„• ⌔ •„)ა` is doing their best)
- Configurable color themes (I considered shipping a more monochrome version but this is my script, I do what I want)
- Further notifications
- Anything else the community suggests
- `Hey buddy` short journaling optional feature
- Virtual pet abuddy
- Abuddy in Ren'Py

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
- sys.sionalarsen@gmail.com
- https://www.linkedin.com/in/sionalarsen/
- Blog: https://sionalarsen-sys.github.io/

P.S. - While a proper mascot is in the wishlist, I created abuddy as an emoticon to try to invoke a penguin. Think of them as Tux's littlest sibling ^.^
