#!/bin/bash

# ─────────────────────────────────────────
#  ACCOUNTABILI-BUDDY — Installer
#  v1.1.2
# ─────────────────────────────────────────

NC=$'\e[0m'
PLUM=$'\e[38;5;13m'
SKY=$'\e[38;5;45m'
LIME=$'\e[38;5;106m'
TEAL=$'\e[38;5;43m'
YELLOW=$'\e[38;5;220m'
GREY=$'\e[38;5;60m'
PINK=$'\e[38;5;219m'
ORANGE=$'\e[38;5;214m'
LAVENDER=$'\e[38;5;141m'

# ── DETECTION — existing install check ──
EXISTING_CONFIG="$HOME/.abuddy/abuddy.cfg"

if [ -f "$EXISTING_CONFIG" ]; then
    # shellcheck source=/dev/null
    source "$EXISTING_CONFIG" 2>/dev/null
    echo ""
    echo -e "${PLUM}─────────────────────────────────────────${NC}"
    echo -e "${PLUM}  ACCOUNTABILI-BUDDY${NC}"
    echo -e "${PLUM}─────────────────────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა📝"
    echo ""
    echo -e "${YELLOW}Looks like abuddy is already installed.${NC}"
    echo ""
    echo -e "${GREY}Found: $EXISTING_CONFIG${NC}"
    [ -n "$ABUDDY_VERSION" ] && echo -e "${GREY}Installed version: $ABUDDY_VERSION${NC}"
    echo ""
    echo -e "${PLUM}install.sh is for fresh installs.${NC}"
    echo -e "${PLUM}To update your script, check for new config keys,${NC}"
    echo -e "${PLUM}or manage your settings — run update.sh instead.${NC}"
    echo ""
    echo -e "${TEAL}  bash $(dirname "${BASH_SOURCE[0]}")/update.sh${NC}"
    echo ""
    read -r -p "$(echo -e "${YELLOW}Run full install anyway? This will overwrite your config and list files. (y/Enter to exit): ${NC}")" FORCE_INSTALL
    if [ "$FORCE_INSTALL" != "y" ] && [ "$FORCE_INSTALL" != "Y" ]; then
        echo ""
        echo -e "${PLUM}Good call.${NC}"
        echo -e "${PLUM}To run the updater, from the repo folder:${NC}"
        echo -e "${TEAL}  bash $(dirname "${BASH_SOURCE[0]}")/update.sh${NC}"
        echo ""
        echo -e "${GREY}If you don't have the repo anymore, grab the latest${NC}"
        echo -e "${GREY}version from github.com/YOUR_USERNAME/accountabili-buddy${NC}"
        echo ""
        echo -e "✦ ૮(„^ ⌔ ^„)ა✦"
        echo ""
        exit 0
fi
echo ""
    echo -e "${YELLOW}Proceeding with full install.${NC}"
    echo -e "${YELLOW}Your config and list files will be overwritten.${NC}"
    echo -e "${YELLOW}Your logs will not be touched.${NC}"
    echo ""
    read -r -p "$(echo -e "${YELLOW}Are you sure? (y/Enter to cancel): ${NC}")" CONFIRM_FORCE
    if [ "$CONFIRM_FORCE" != "y" ] && [ "$CONFIRM_FORCE" != "Y" ]; then
        echo ""
        echo -e "${PLUM}Cancelled. Your files are untouched.${NC}"
        echo ""
        echo -e "✦ ૮(„^ ⌔ ^„)ა✦"
        echo ""
        exit 0
    fi
    echo ""
fi
# ── INTRO ──

echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  ACCOUNTABILI-BUDDY INTRO${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა ${PLUM}Hi!${NC}"
    sleep 0.5
echo -e "${PLUM}🐧I'm Abuddy — a terminal-based focus timer${NC}"
echo -e "${PLUM}with built-in self care breaks, session logging,${NC}"
echo -e "${PLUM}and a wins tracker so you remember what you've${NC}"
echo -e "${PLUM}already pulled off.${NC}"
echo ""
echo -e "${PLUM}The Pomodoro technique breaks work into focused${NC}"
echo -e "${PLUM}sessions with short breaks between them. I do${NC}"
echo -e "${PLUM}that — and then a little more.${NC}"
echo ""
echo -e "${GREY}Here's what this installer is going to do:${NC}"
echo -e "${GREY}  1. Choose where to put your files${NC}"
echo -e "${GREY}  2. Set up your list files with starter content${NC}"
echo -e "${GREY}  3. Optionally add an 'abuddy' shortcut command${NC}"
echo -e "${GREY}  4. Run a quick demo so you know what to expect${NC}"
echo ""
read -r -p "$(echo -e "${LIME}Press Enter to get started (Step 1 of 4)...${NC}")" _

# ── STEP 1 — DIRECTORY ──

echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  STEP 1 OF 4 — WHERE TO PUT YOUR FILES${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა💾"
echo -e "${PLUM}I'll create a folder to store your list files,${NC}"
echo -e "${PLUM}config, and session logs.${NC}"
echo ""
echo -e "${PLUM}The default is ${TEAL}~/.abuddy${PLUM} — a hidden directory.${NC}"
echo -e "${PLUM}On Linux, folders starting with a dot are hidden${NC}"
echo -e "${PLUM}from normal file listings. You won't see it with${NC}"
echo -e "${PLUM}just ${TEAL}ls${PLUM} — use ${TEAL}ls -a${PLUM} to show hidden items.${NC}"
echo -e "${PLUM}This is normal and intentional. Your files are${NC}"
echo -e "${PLUM}still there — they're just tucked away.${NC}"
echo ""
read -r -p "$(echo -e "${LIME}Press Enter to use ~/.abuddy, or type a custom path: ${NC}")" INPUT_DIR

if [ -z "$INPUT_DIR" ]; then
    ABUDDY_DIR="$HOME/.abuddy"
else
    # Expand ~ manually in case user types it
    ABUDDY_DIR="${INPUT_DIR/#\~/$HOME}"
fi

while true; do
    echo ""
    echo -e "${TEAL}Install directory: $ABUDDY_DIR${NC}"
    read -r -p "$(echo -e "${LIME}Confirm? (Enter to continue, or type 'no' to change): ${NC}")" CONFIRM_DIR

    if [ "$CONFIRM_DIR" != "no" ]; then
        break
    fi

    read -r -p "$(echo -e "${LIME}Enter your preferred path: ${NC}")" INPUT_DIR
    ABUDDY_DIR="${INPUT_DIR/#\~/$HOME}"
done

mkdir -p "$ABUDDY_DIR"
echo ""
sleep 0.5
echo -e "${LIME}Created: $ABUDDY_DIR${NC}"
echo ""
read -r -p "$(echo -e "${LIME}Press Enter to continue (Step 2 of 4)...${NC}")" _

# ── STEP 2 — FILES ──

echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  STEP 2 OF 4 — SETTING UP YOUR FILES${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა📝"
echo -e "${PLUM}I'm going to copy the script, write your config,${NC}"
echo -e "${PLUM}and create your list files with some starter${NC}"
echo -e "${PLUM}content. You can edit any of these files later${NC}"
echo -e "${PLUM}to make them your own.${NC}"
echo ""
read -r -p "$(echo -e "${LIME}Press Enter to continue...${NC}")" _

# Copy abuddy.sh
SCRIPT_SOURCE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/abuddy.sh"

if [ ! -f "$SCRIPT_SOURCE" ]; then
    echo ""
    echo -e "${PINK}Could not find abuddy.sh in the same directory as install.sh.${NC}"
    echo -e "${PINK}Make sure both files are in the same folder before running the installer.${NC}"
    exit 1
fi

cp "$SCRIPT_SOURCE" "$ABUDDY_DIR/abuddy.sh"
chmod 700 "$ABUDDY_DIR/abuddy.sh"
sleep 0.1
echo -e "${LIME}Copied:  $ABUDDY_DIR/abuddy.sh${NC}"

# Write abuddy.cfg
cat > "$ABUDDY_DIR/abuddy.cfg" << EOF
# ─────────────────────────────────────────
#  ACCOUNTABILI-BUDDY CONFIG
#  abuddy.cfg — generated by install.sh
#  edit this file to customize your setup
# ─────────────────────────────────────────
ABUDDY_VERSION="1.1"

# ── PATHS ──
ABUDDY_DIR="$ABUDDY_DIR"

# List files — manual (you fill these)
EXERCISES_FILE="\$ABUDDY_DIR/exercises.txt"
GOALS_FILE="\$ABUDDY_DIR/goals.txt"
QUOTES_FILE="\$ABUDDY_DIR/quotes.txt"
SESSION_Q_FILE="\$ABUDDY_DIR/session-q.txt"
BREAK_Q_FILE="\$ABUDDY_DIR/break-q.txt"

# List files — auto (abuddy adds to these during sessions)
AUTO_NUDGES_FILE="\$ABUDDY_DIR/auto-nudges.txt"
AUTO_WINS_FILE="\$ABUDDY_DIR/auto-wins.txt"
AUTO_REWARDS_FILE="\$ABUDDY_DIR/auto-rewards.txt"

# Log
LOG_FILE="\$ABUDDY_DIR/abuddy.log.md"

# ── TIMER DEFAULTS ──
DEFAULT_WORK=25
DEFAULT_BREAK=5
DEFAULT_SESSIONS=4
BIG_BREAK=20

# ── LABEL ──
FOCUS_NAME="Focus Round"

# ── TOGGLES ──
ALERT_MODE=both         # both / sound / flash / silent
REWARDS_ENABLED=ask     # ask / always / off
COMPLETION_TRACKING=ask # ask / always / off
BUFFER_REVIEW=ask       # ask / always / off
BREAK_REFLECTION=ask    # ask / always / off
EOF

# Manual list files
cat > "$ABUDDY_DIR/exercises.txt" << 'EOF'
Move away from your work area for a minute
Roll your shoulders back ten times
Stretch your neck slowly side to side
Do a low impact short cardio exercise that makes sense for you
Refill your water and take a few sips before sitting back down
Go outside or to a window for sixty seconds
EOF

cat > "$ABUDDY_DIR/goals.txt" << 'EOF'
Finish one topic you've been putting off
Review your notes from this week
Work through one practice problem set
Read one chapter or module
Tidy up your notes from last session
EOF

cat > "$ABUDDY_DIR/quotes.txt" << 'EOF'
Add your favourite motivational quotes here, one per line.
EOF

cat > "$ABUDDY_DIR/auto-rewards.txt" << 'EOF'
a hot drink and five minutes outside
your favourite snack
a short walk around the block
ten minutes of a show or video
a chapter of whatever you're reading
a stretch and some fresh air
EOF

cat > "$ABUDDY_DIR/session-q.txt" << 'EOF'
What went well this session?
What would you do differently next time?
What's one thing you actually learned today?
What's still on your mind that you haven't dealt with yet?
What are you proud of from today?
EOF

cat > "$ABUDDY_DIR/break-q.txt" << 'EOF'
What did you do on your break?
Did anything on your break re-energize you?
What's one thing that helped you reset just now?
What movement actually felt good today?
What's something small that made the break worthwhile?
What do you want to remember to do next break?
Did anything helpful happen on your break?
EOF

# Auto list files — abuddy writes to these during sessions
cat > "$ABUDDY_DIR/auto-nudges.txt" << 'EOF'
How's your posture right now?
Have you had water recently?
Take three slow breaths before the next session
Blink a few times and look at something across the room
Check in — how are you actually feeling?
You're doing the thing. That counts.
EOF

cat > "$ABUDDY_DIR/auto-wins.txt" << 'EOF'
You installed abuddy. That's a win.
You showed up. Seriously, that matters.
You're building something. Keep going.
EOF

# Set permissions
chmod 700 "$ABUDDY_DIR/abuddy.sh"
chmod 600 "$ABUDDY_DIR/abuddy.cfg"
chmod 600 "$ABUDDY_DIR/exercises.txt"
chmod 600 "$ABUDDY_DIR/goals.txt"
chmod 600 "$ABUDDY_DIR/quotes.txt"
chmod 600 "$ABUDDY_DIR/auto-rewards.txt"
chmod 600 "$ABUDDY_DIR/session-q.txt"
chmod 600 "$ABUDDY_DIR/break-q.txt"
chmod 600 "$ABUDDY_DIR/auto-nudges.txt"
chmod 600 "$ABUDDY_DIR/auto-wins.txt"

sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/exercises.txt${NC}"
sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/goals.txt${NC}"
sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/quotes.txt${NC}"
sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/auto-rewards.txt${NC}"
sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/session-q.txt${NC}"
sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/break-q.txt${NC}"
sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/auto-nudges.txt${NC}"
sleep 0.2
echo -e "${LIME}Created: $ABUDDY_DIR/auto-wins.txt${NC}"
sleep 0.2
echo -e "${LIME}All starter files created.${NC}"
sleep 0.2
echo ""
echo -e "${PLUM}All files are yours to edit. Add, remove, or${NC}"
echo -e "${PLUM}rewrite any entries to make abuddy your own.${NC}"
echo ""
read -r -p "$(echo -e "${LIME}Press Enter to continue (Step 3 of 4)...${NC}")" _
# ── STEP 3 — ALIAS ──

echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  STEP 3 OF 4 — SHORTCUT COMMAND${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა⌨"
echo -e "${PLUM}An alias is a shortcut — instead of typing the${NC}"
echo -e "${PLUM}full path to run abuddy, you could just type${NC}"
echo -e "${TEAL}abuddy${PLUM} from anywhere.${NC}"
echo ""
echo -e "${PLUM}This adds one line to your ${TEAL}~/.bash_aliases${PLUM} file,${NC}"
echo -e "${PLUM}which your shell loads automatically on login.${NC}"
echo -e "${PLUM}You can remove it any time by editing that file.${NC}"
echo ""
read -r -p "$(echo -e "${LIME}Add 'abuddy' as a shortcut command? (y/n): ${NC}")" ADD_ALIAS

if [ "$ADD_ALIAS" = "y" ] || [ "$ADD_ALIAS" = "Y" ]; then
    ALIAS_LINE="alias abuddy='bash $ABUDDY_DIR/abuddy.sh'"

    # Create ~/.bash_aliases if it doesn't exist
    if [ ! -f "$HOME/.bash_aliases" ]; then
        touch "$HOME/.bash_aliases"
        sleep 0.2
        echo -e "${LIME}Created ~/.bash_aliases${NC}"
    fi

    # Check if alias already exists
    if grep -q "alias abuddy=" "$HOME/.bash_aliases"; then
        echo ""
        sleep 0.2
        echo -e "${YELLOW}An 'abuddy' alias already exists in ~/.bash_aliases.${NC}"
        echo -e "${YELLOW}Skipping to avoid duplicates. Edit the file manually if you need to update it.${NC}"
    else
        {
    echo ""
    echo "# accountabili-buddy"
    echo "$ALIAS_LINE"
} >> "$HOME/.bash_aliases"
        sleep 0.2
        echo ""
        echo -e "${LIME}Alias added to ~/.bash_aliases${NC}"
        echo ""
        echo -e "${PLUM}To use it in this terminal session right now, run:${NC}"
        echo -e "${TEAL}  source ~/.bash_aliases${NC}"
        echo -e "${PLUM}Or just open a new terminal — it will load automatically.${NC}"
    fi
else
    echo ""
    echo -e "${PLUM}No problem. You can run abuddy any time with:${NC}"
    echo -e "${TEAL}  bash $ABUDDY_DIR/abuddy.sh${NC}"
fi
echo ""
read -r -p "$(echo -e "${LIME}Press Enter to continue (Step 4 of 4)...${NC}")" _
# ── STEP 4 — DEMO ──

echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  STEP 4 OF 4 — QUICK DEMO${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა⧗"
echo -e "${PLUM}Let me show you what a session looks like.${NC}"
echo -e "${PLUM}This isn't a real timer — just a walkthrough${NC}"
echo -e "${PLUM}so you know what to expect and how to interact.${NC}"
echo ""
read -r -p "$(echo -e "${LIME}Run the demo? (y/n): ${NC}")" RUN_DEMO


if [ "$RUN_DEMO" = "y" ] || [ "$RUN_DEMO" = "Y" ]; then

    echo ""
    echo -e "${LAVENDER}── THE SETUP BLOCK ──────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა☀"
    echo -e "${PLUM}I start by helping you set your intention and${NC}"
    echo -e "${PLUM}customize the session length. Defaults are set${NC}"
    echo -e "${PLUM}in your config — just press Enter to use them.${NC}"
    echo ""
    echo -e "${ORANGE}What's your goal for this focus round? (demo): ${NC}"
    echo -e "${PLUM}>*To learn about abuddy and what makes them tick.* Enter${NC}"
    echo ""
    echo -e "${PINK}Any reminders for this session? (demo): ${NC}"
    echo -e "${PLUM}>*Check the laundry. Send that text.* Enter${NC}"
    echo ""
    echo -e "${LAVENDER}Want to track completed goals this session? (demo): ${NC}"
    echo -e "${PLUM}>*y* — abuddy will log when you mark a goal done${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to continue the demo...${NC}")" _

    echo ""
    echo -e "${LAVENDER}── THE REWARD BLOCK ─────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა🎁"
    echo -e "${PLUM}At the start of each focus round you can set a${NC}"
    echo -e "${PLUM}small reward to look forward to on your break.${NC}"
    echo -e "${PLUM}Pick one from your list, type your own, or skip.${NC}"
    echo ""
    echo -e "${YELLOW}Suggested reward: a hot drink and five minutes outside${NC}"
    echo -e "${YELLOW}Set a reward for this focus round? (Enter / r / type / s to skip): (demo)${NC}"
    echo -e "${PLUM}>*a biscuit* Enter — typed rewards can be saved to your list${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to continue the demo...${NC}")" _

    echo ""
    echo -e "${LAVENDER}── THE FOCUS BLOCK ──────────────────────────${NC}"
    echo ""
    echo -e "${PLUM}When a focus round starts you'll see something like this:${NC}"
    echo ""
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo -e "${SKY}  FOCUS ROUND 1 of 4${NC}"
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo ""
    echo -e "${PLUM}  Goal: To learn about abuddy and what makes them tick${NC}"
    echo -e "${YELLOW}  Reward: a biscuit${NC}"
    echo ""
    echo -e "Started:${TEAL} $(date +"%I:%M %p")${NC}"
    echo -e "Expected break:${PINK} $(date -d "+25 minutes" +"%I:%M %p")${NC}"
    echo -e "${GREY}Press Enter at any time to skip to break.${NC}"
    echo ""
    echo -e "${PLUM}The timer runs silently. Work until it ends,${NC}"
    echo -e "${PLUM}or press Enter when you reach a good stopping point.${NC}"
    echo -e "${PLUM}When the round ends there's a manual start prompt${NC}"
    echo -e "${PLUM}for the break — wrap up your thought first.${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to continue the demo...${NC}")" _

    echo ""
    echo -e "${LAVENDER}── THE BREAK BLOCK ──────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა🎁"
    echo -e "${PLUM}Break opens with your reward — you earned it.${NC}"
    echo -e "${PLUM}Then your reminder, then movement and self care${NC}"
    echo -e "${PLUM}suggestions that rotate every minute.${NC}"
    echo ""
    echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
    echo -e "${LAVENDER}  BREAK — 5 minutes${NC}"
    echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა🎁"
    echo -e "${YELLOW}Congrats — you get your reward: a biscuit${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა📝"
    echo -e "${PINK}★ Don't forget: Check the laundry. Send that text.${NC}"
    echo ""
    echo -e "${TEAL}Stand up and walk around for a minute${NC}"
    echo -e "${GREY}X minutes remaining...${NC}"
    echo ""
    echo -e "${PLUM}At the end of the break abuddy asks a quick${NC}"
    echo -e "${PLUM}reflection question — did anything on your break${NC}"
    echo -e "${PLUM}re-energize you? You can save your answer to your${NC}"
    echo -e "${PLUM}nudges list to keep it growing over time.${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to continue the demo...${NC}")" _

    echo ""
    echo -e "${LAVENDER}── BETWEEN ROUNDS ───────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა⧖"
    echo -e "${PLUM}Between rounds you can update your goal, reminder,${NC}"
    echo -e "${PLUM}and reward for the next round. Goal prompt gives${NC}"
    echo -e "${PLUM}you three options:${NC}"
    echo ""
    echo -e "${PLUM}  Enter       — keep current goal${NC}"
    echo -e "${PLUM}  Type new    — switch tasks${NC}"
    echo -e "${PLUM}  d           — mark complete, then set next goal${NC}"
    echo ""
    echo -e "${PLUM}Marking complete logs the time so you can see${NC}"
    echo -e "${PLUM}what you actually got done during the session.${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to continue the demo...${NC}")" _

    echo ""
    echo -e "${LAVENDER}── THE END BLOCK ────────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა✨"
    echo -e "${PLUM}After all your rounds, you'll get a reflection${NC}"
    echo -e "${PLUM}question, an optional buffer time review, and${NC}"
    echo -e "${PLUM}a space to log a win from the session.${NC}"
    echo ""
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo -e "${SKY}  SESSION COMPLETE${NC}"
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo ""
    echo -e "${LIME}4 focus rounds complete. Nice work.${NC}"
    echo ""
    echo -e "${ORANGE}Reflection: What went well this session? (demo):${NC}"
    echo -e "${PLUM}>*I got through the abuddy demo* Enter${NC}"
    echo ""
    echo -e "${LAVENDER}Want to review your wrap-up buffer times? (demo):${NC}"
    echo -e "${PLUM}>*y* — shows how long after each round ended before${NC}"
    echo -e "${PLUM}you actually started the break. Useful for figuring${NC}"
    echo -e "${PLUM}out if your rounds are the right length for your work.${NC}"
    echo ""
    echo -e "${YELLOW}One win from this session — keep it to one sentence. (demo):${NC}"
    echo -e "${PLUM}>*I tried something new* Enter${NC}"
    echo ""
    echo -e "${PLUM}Then abuddy offers a big break before your next${NC}"
    echo -e "${PLUM}session — recommended after four rounds.${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to continue the demo...${NC}")" _

    echo ""
    echo -e "${LAVENDER}── THE LOG ──────────────────────────────────${NC}"
    echo ""
    echo -e "${PLUM}Everything gets written to abuddy.log.md —${NC}"
    echo -e "${PLUM}start and finish times, all your goals, completed${NC}"
    echo -e "${PLUM}goal timestamps, break reflections, buffer times${NC}"
    echo -e "${PLUM}if you saved them, reflection Q and A, and your win.${NC}"
    echo ""
    echo -e "${PLUM}Wins also go into auto-wins.txt to greet you${NC}"
    echo -e "${PLUM}at the start of your next session.${NC}"
    echo -e "${PLUM}Nudges saved from breaks go into auto-nudges.txt${NC}"
    echo -e "${PLUM}and rotate back in during future breaks.${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა♡"
    echo -e "${PLUM}Your lists grow with you. The longer you use abuddy${NC}"
    echo -e "${PLUM}the more it sounds like you.${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to continue the demo...${NC}")" _

    # Bell test
    echo ""
    echo -e "${LAVENDER}── BELL TEST ────────────────────────────────${NC}"
    echo ""
    echo -e "૮(„• ⌔ •„)ა♪ ♫"
    echo -e "${PLUM}Abuddy rings a bell at transitions — round to break,${NC}"
    echo -e "${PLUM}break to round. Make sure your sound is on.${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}Press Enter to ring the bell...${NC}")" _
    echo -e "\a"
    echo ""
    echo -e "${PLUM}Did you hear something?${NC}"
    echo ""
    read -r -p "$(echo -e "${LIME}(y/n): ${NC}")" HEARD_BELL

    if [ "$HEARD_BELL" = "n" ] || [ "$HEARD_BELL" = "N" ]; then
        echo ""
        echo -e "${YELLOW}No sound — that's a common terminal setting.${NC}"
        echo -e "${YELLOW}Check the README for fixes. The short version:${NC}"
        echo ""
        echo -e "${GREY}  VS Code:     Settings → Accessibility → Accessibility Signals${NC}"
        echo -e "${GREY}               Terminal Bell → sound: on${NC}"
        echo -e "${GREY}  Other terminals: check your terminal's bell settings${NC}"
        echo -e "${GREY}  PowerShell SSH:  usually works without changes${NC}"
        echo ""
        echo -e "${PLUM}The timer works fine without the bell —${NC}"
        echo -e "${PLUM}you just won't get an audio nudge at transitions.${NC}"
    else
        echo ""
        echo -e "${LIME}You're all set.${NC}"
    fi

fi

read -r -p "$(echo -e "${LIME}Press Enter to recap...${NC}")" _
# ── SUMMARY ──

echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  YOU'RE READYY${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა[✓]"
echo -e "${PLUM}Here's where everything landed:${NC}"
echo ""
echo -e "${TEAL}  Script:  $ABUDDY_DIR/abuddy.sh${NC}"
echo -e "${TEAL}  Config:  $ABUDDY_DIR/abuddy.cfg${NC}"
echo -e "${TEAL}  Lists:   $ABUDDY_DIR/*.txt${NC}"
echo -e "${TEAL}  Log:     $ABUDDY_DIR/abuddy.log.md${NC}"
echo ""
echo -e "${PLUM}To run abuddy:${NC}"
if [ "$ADD_ALIAS" = "y" ] || [ "$ADD_ALIAS" = "Y" ]; then
    echo -e "${TEAL}  abuddy${NC}"
    echo -e "${GREY}  (after sourcing ~/.bash_aliases or opening a new terminal)${NC}"
else
    echo -e "${TEAL}  bash $ABUDDY_DIR/abuddy.sh${NC}"
fi
echo ""
echo -e "${PLUM}To make it yours — open any .txt file in your${NC}"
echo -e "${PLUM}install directory and edit the entries. One item${NC}"
echo -e "${PLUM}per line. That's it.${NC}"
echo ""
echo -e "${PLUM}Good luck out there.${NC}"
echo ""
echo -e "✦ ૮(„^ ⌔ ^„)ა✦"