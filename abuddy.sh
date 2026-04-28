#!/bin/bash

# ─────────────────────────────────────────
#  ACCOUNTABILI-BUDDY (abuddy)
#  A pomodoro timer with built-in self care
# ─────────────────────────────────────────

# ── CONFIG ──
CONFIG="$HOME/.abuddy/abuddy.cfg"

if [ ! -f "$CONFIG" ]; then
    echo "abuddy config not found. Have you run install.sh?"
    exit 1
fi

source "$CONFIG"

# ── COLORS ──
NC=$'\e[0m'
SKY=$'\e[38;5;45m'
GREY=$'\e[38;5;60m'
PLUM=$'\e[38;5;13m'
ORANGE=$'\e[38;5;214m'
LIME=$'\e[38;5;106m'
YELLOW=$'\e[38;5;220m'
TEAL=$'\e[38;5;43m'
PINK=$'\e[38;5;213m'
LAVENDER=$'\e[38;5;141m'

# Color arrays
# RAINBOW_CONNECTION: red, yellow, coral orange, moss green, cornflower blue, deep purple
# TRAFFIC: salmon orange, dusty pink, yellow, purple, green
RAINBOW_CONNECTION=($'\e[38;5;9m' $'\e[38;5;226m' $'\e[38;5;124m' $'\e[38;5;70m' $'\e[38;5;4m' $'\e[38;5;56m')
TRAFFIC=($'\e[38;5;1m' $'\e[38;5;219m' $'\e[38;5;3m' $'\e[38;5;5m' $'\e[38;5;2m')

# ── GOAL LOG ──
GOAL_LOG=()

# ── SETUP ──

echo ""
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo -e "${PLUM}  ACCOUNTABILI-BUDDY${NC}"
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo ""
echo -e "${PLUM}It's me!${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა📝"
echo ""
echo -e "${PLUM}🐧Abuddy!🐧${NC}"
echo -e "${PLUM}Let's get started!${NC}"
echo ""

# Customize the session — defaults fall back to config values
read -p "$(echo -e "${LIME}Work block duration in minutes (default ${DEFAULT_WORK}): ${NC}")" INPUT_DURATION
DURATION=${INPUT_DURATION:-$DEFAULT_WORK}

read -p "$(echo -e "${SKY}Break block duration in minutes (default ${DEFAULT_BREAK}): ${NC}")" INPUT_BREAK
BREAK_DURATION=${INPUT_BREAK:-$DEFAULT_BREAK}

read -p "$(echo -e "${YELLOW}How many sessions would you like to do? (default ${DEFAULT_SESSIONS}): ${NC}")" INPUT_SESSIONS
SESSIONS=${INPUT_SESSIONS:-$DEFAULT_SESSIONS}

# Accountability check — goal is saved to the log
read -p "$(echo -e "${ORANGE}What's your goal for this session? (enter for a random prompt): ${NC}")" INPUT_GOAL
GOAL=${INPUT_GOAL:-"$(shuf -n 1 "$GOALS")"}
GOAL_LOG+=("$GOAL")

# Session reminder — stored in memory only, not logged
read -p "$(echo -e "${PINK}Any specific reminders for this session? (enter to skip): ${NC}")" SESSION_REMINDER

# Summary before starting
echo ""
echo -e "${LAVENDER}Goal: $GOAL${NC}"
echo -e "${TEAL}$SESSIONS sessions × ${DURATION} min work / ${BREAK_DURATION} min break${NC}"
echo ""
read -p "$(echo -e "${LIME}Press Enter to begin...${NC}")" dummy

# Past win — reminds you that you've done it before
if [ -f "$WINS_FILE" ] && [ -s "$WINS_FILE" ]; then
    PAST_WIN=$(shuf -n 1 "$WINS_FILE")
    RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
    echo ""
    echo -e "૮(„• ⌔ •„)ა✦"
    echo -e "${RAINBOW_WAY}A win from a past session: $PAST_WIN${NC}"
fi

# ── MAIN LOOP ──
SESSION_START=$(date +"%I:%M %p")

for i in $(seq 1 $SESSIONS); do

    # ── WORK BLOCK ──
    echo -e "\a"
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo -e "${SKY}  SESSION $i of $SESSIONS${NC}"
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo ""
    echo -e "${PLUM}  Goal: $GOAL${NC}"
    echo ""
    echo -e "Started: ${TEAL} $(date +"%I:%M %p")${NC}"
    echo -e "Expected break:${PINK}  $(date -d "+${DURATION} minutes" +"%I:%M %p")${NC}"
    echo -e "${GREY}Press Enter at any time to skip to break.${NC}"
    read -t $(( DURATION * 60 ))
    echo -ne "\r\e[K"

    echo -e "\a"
    read -p "$(echo -e "${LIME}Session complete - press Enter to start break${NC}")" dummy

    # ── BREAK BLOCK ──
    echo -e "\a"
    echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
    if [ "$i" -eq "$SESSIONS" ]; then
        echo -e "${LAVENDER}  FINAL BREAK${NC}"
        echo ""
        echo -e "૮(„• ⌔ •„)ა⧗"
        echo -e "${PLUM}I recommend taking a 20 minute break after the reflection before trying another session!${PLUM}"
    else
        echo -e "${LAVENDER}  BREAK — ${BREAK_DURATION} minutes${NC}"
    fi
    echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
    echo ""
    echo -e "Started:${TEAL} $(date +"%I:%M %p")${NC}"
    if [ "$i" -lt "$SESSIONS" ]; then
        echo -e "Back to work: ${PINK} $(date -d "+${BREAK_DURATION} minutes" +"%I:%M %p")${NC}"
    fi
    echo ""

    # Session reminder — always shown first if set
    if [ -n "$SESSION_REMINDER" ]; then
        RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
        echo -e "૮(„• ⌔ •„)ა📝"
        echo -e "${RAINBOW_WAY}★ Don't forget: $SESSION_REMINDER${NC}"
        echo ""
    fi

    # Build break content array — all picks happen upfront
    BREAK_CONTENT=(
        "$(shuf -n 1 "$EXERCISES")"
        "$(shuf -n 1 "$NUDGES")"
        "$(shuf -n 1 "$EXERCISES")"
        "$(shuf -n 1 "$NUDGES")"
        "$(shuf -n 1 "$EXERCISES")"
        "$(shuf -n 1 "$NUDGES")"
    )

    # Show first item immediately
    RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
    echo -e "${RAINBOW_WAY}${BREAK_CONTENT[0]}${NC}"

    # Countdown loop — one tick per minute
    REMAINING=$BREAK_DURATION
    INDEX=1
    COLOR_INDEX=0

    while [ $REMAINING -gt 1 ]; do
        echo ""
        read -t 60 -p "$(echo -e "${GREY}(press Enter to skip break)${NC}")" dummy
        echo ""

        REMAINING=$(( REMAINING - 1 ))
        CONTENT_INDEX=$(( INDEX % ${#BREAK_CONTENT[@]} ))
        CURRENT_COLOR=${TRAFFIC[$COLOR_INDEX]}

        RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
        echo ""
        echo -e "${RAINBOW_WAY}${BREAK_CONTENT[$CONTENT_INDEX]}${NC}"
        echo -e "${CURRENT_COLOR}$REMAINING minute(s) remaining${NC}"

        # Advance color index — stalls at final color to signal time passing
        if [ $COLOR_INDEX -lt $(( ${#TRAFFIC[@]} - 1 )) ]; then
            COLOR_INDEX=$(( COLOR_INDEX + 1 ))
        fi
        INDEX=$(( INDEX + 1 ))
    done

    # Final break minute
    echo ""
    if [ "$i" -eq "$SESSIONS" ]; then
        read -t 60 -p "$(echo -e "${GREY}(press Enter to skip to reflection)${NC}")" dummy
    else
        read -t 60 -p "$(echo -e "${GREY}(press Enter to skip to next session)${NC}")" dummy
    fi

    echo -e "\a"

    # ── BETWEEN-SESSION CHECK — skip after last session ──
    if [ $i -lt $SESSIONS ]; then
        echo ""
        echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
        echo ""
        echo -e "૮(„• ⌔ •„)ა📝"
        read -p "$(echo -e "${YELLOW}Update reminder for next break? (Enter to keep current, or type new one): ${NC}")" NEW_REMINDER
        if [ -n "$NEW_REMINDER" ]; then
            SESSION_REMINDER="$NEW_REMINDER"
            echo -e "${LIME}Reminder updated.${NC}"
        fi
        echo ""
        read -p "$(echo -e "${PLUM}Update goal for next session? (Enter to keep current, or type new one): ${NC}")" NEW_GOAL
        if [ -n "$NEW_GOAL" ]; then
            GOAL="$NEW_GOAL"
            GOAL_LOG+=("$GOAL")
        fi
        echo ""
        read -p "$(echo -e "${LIME}Press Enter to start session $(( i + 1 ))...${NC}")" dummy
    fi

done

# ── END BLOCK ──

echo ""
echo -e "\a"
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo -e "${PLUM}  SESSION COMPLETE${NC}"
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo ""
echo -e "${LIME}$SESSIONS blocks done. Nice work.${NC}"
echo -e "${TEAL}Started:  $SESSION_START${NC}"
echo -e "${PINK}Finished: $(date +"%I:%M %p")${NC}"
echo ""

# Reflection question — random pull from reflections file
REFLECTION_Q=$(shuf -n 1 "$REFLECTIONS")
echo -e "૮(„• ⌔ •„)ა⯎"
read -p "$(echo -e "${ORANGE}Reflection: $REFLECTION_Q ${NC}")" REFLECTION_A

echo ""
read -p "$(echo -e "${YELLOW}One win from this session — keep it to one sentence. (Enter to skip): ${NC}")" WIN
if [ -n "$WIN" ]; then
    echo "$WIN" >> "$WINS_FILE"
    echo -e "${LIME}Saved to wins.txt.${NC}"
fi

# ── SESSION LOG ──
{
    echo "## $(date +"%Y-%m-%d") — $(date +"%I:%M %p")"
    echo ""
    echo "- **Sessions completed:** $SESSIONS"
    echo "- **Started:** $SESSION_START"
    echo "- **Finished:** $(date +"%I:%M %p")"
    echo "- **Goals:**"
    for g in "${GOAL_LOG[@]}"; do
        echo "  - $g"
    done
    echo "- **Reflection:** $REFLECTION_Q"
    echo "  - $REFLECTION_A"
    [ -n "$WIN" ] && echo "- **Win:** $WIN"
    echo ""
    echo "---"
    echo ""
} >> "$LOG"

echo ""
echo -e "૮(„• ⌔ •„)ა📝"
echo -e "${SKY}Session logged.${NC}"
echo ""