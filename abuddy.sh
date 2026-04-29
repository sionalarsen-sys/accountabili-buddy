#!/bin/bash

# ─────────────────────────────────────────
#  ACCOUNTABILI-BUDDY (abuddy)
#  A pomodoro timer with built-in self care
#  Version 1.1
# ─────────────────────────────────────────
# shellcheck disable=SC2034
ABUDDY_VERSION="1.1" # read by update.sh — not used internally

# ── CONFIG ──
# shellcheck source=/dev/null
CONFIG="$HOME/.abuddy/abuddy.cfg"

if [ ! -f "$CONFIG" ]; then
    echo "abuddy config not found. Have you run install.sh?"
    exit 1
fi

# shellcheck source=/dev/null
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

# ── SESSION STATE ──
GOAL_LOG=()
BREAK_ANSWERS=()
BUFFER_TIMES=()
ROUND_REWARD=""
REWARD_SOURCE=""
TRACK_COMPLETION=false
SESSION_START=""

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
read -r -r -p "$(echo -e "${LIME}Work duration in minutes (default ${DEFAULT_WORK}): ${NC}")" INPUT_DURATION
DURATION=${INPUT_DURATION:-$DEFAULT_WORK}

read -r -r -p "$(echo -e "${SKY}Break duration in minutes (default ${DEFAULT_BREAK}): ${NC}")" INPUT_BREAK
BREAK_DURATION=${INPUT_BREAK:-$DEFAULT_BREAK}

read -r -r -p "$(echo -e "${YELLOW}How many focus ${FOCUS_LABEL}s? (default ${DEFAULT_SESSIONS}): ${NC}")" INPUT_SESSIONS
SESSIONS=${INPUT_SESSIONS:-$DEFAULT_SESSIONS}

# Goal — saved to log
read -r -r -p "$(echo -e "${ORANGE}What's your goal for this ${FOCUS_LABEL}? (Enter for a random prompt): ${NC}")" INPUT_GOAL
GOAL=${INPUT_GOAL:-"$(shuf -n 1 "$GOALS_FILE")"}
GOAL_LOG+=("$GOAL")

# Session reminder — memory only, not logged
read -r -r -p "$(echo -e "${PINK}Any reminders for this session? (Enter to skip): ${NC}")" SESSION_REMINDER

# Completion tracking — if COMPLETION_TRACKING=ask, prompt. always=on, off=skip
if [ "$COMPLETION_TRACKING" = "ask" ]; then
    read -r -r -p "$(echo -e "${LAVENDER}Track completed goals this session? (y/Enter to skip): ${NC}")" TRACK_INPUT
    [ "$TRACK_INPUT" = "y" ] || [ "$TRACK_INPUT" = "Y" ] && TRACK_COMPLETION=true
elif [ "$COMPLETION_TRACKING" = "always" ]; then
    TRACK_COMPLETION=true
fi

# Summary before starting
echo ""
echo -e "${LAVENDER}Goal: $GOAL${NC}"
echo -e "${TEAL}$SESSIONS focus ${FOCUS_LABEL}s × ${DURATION} min work / ${BREAK_DURATION} min break${NC}"
[ -n "$SESSION_REMINDER" ] && echo -e "${PINK}Reminder: $SESSION_REMINDER${NC}"
echo ""
read -r -r -p "$(echo -e "${LIME}Press Enter to begin...${NC}")" _

# Past win — reminds you that you've done it before
if [ -f "$AUTO_WINS_FILE" ] && [ -s "$AUTO_WINS_FILE" ]; then
    PAST_WIN=$(shuf -n 1 "$AUTO_WINS_FILE")
    RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
    echo ""
    echo -e "૮(„• ⌔ •„)ა✦"
    echo -e "${RAINBOW_WAY}A win from a past session: $PAST_WIN${NC}"
fi


for i in $(seq 1 "$SESSIONS"); do

    # ── TOP OF ROUND — reward, goal, reminder ──
    if [ "$i" -eq 1 ]; then
        # First round — no previous reward to offer to save
        # Set reward for this round
        if [ "$REWARDS_ENABLED" != "off" ]; then
            echo ""
            echo -e "${PLUM}─────────────────────────────────────────${NC}"
            echo ""
            if [ -f "$REWARDS_FILE" ] && [ -s "$REWARDS_FILE" ]; then
                SUGGESTED=$(shuf -n 1 "$REWARDS_FILE")
                echo -e "૮(„• ⌔ •„)ა🎁"
                echo -e "${YELLOW}Suggested reward: $SUGGESTED${NC}"
            fi
            read -r -r -p "$(echo -e "${YELLOW}Set a reward for this focus ${FOCUS_LABEL}? (Enter for suggestion / r for random / or type your own / s to skip): ${NC}")" REWARD_INPUT
            if [ "$REWARD_INPUT" = "s" ] || [ "$REWARD_INPUT" = "S" ]; then
                ROUND_REWARD=""
                REWARD_SOURCE=""
            elif [ "$REWARD_INPUT" = "r" ] || [ "$REWARD_INPUT" = "R" ]; then
                if [ -f "$REWARDS_FILE" ] && [ -s "$REWARDS_FILE" ]; then
                    ROUND_REWARD=$(shuf -n 1 "$REWARDS_FILE")
                    REWARD_SOURCE="list"
                else
                    echo -e "${GREY}No rewards list found — type one in instead.${NC}"
                    read -r -r -p "$(echo -e "${YELLOW}Your reward: ${NC}")" ROUND_REWARD
                    REWARD_SOURCE="typed"
                fi
            elif [ -z "$REWARD_INPUT" ] && [ -n "$SUGGESTED" ]; then
                ROUND_REWARD="$SUGGESTED"
                REWARD_SOURCE="list"
            elif [ -n "$REWARD_INPUT" ]; then
                ROUND_REWARD="$REWARD_INPUT"
                REWARD_SOURCE="typed"
            fi
        fi
    else
        # ── BETWEEN ROUNDS ──
        echo ""
        echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
        echo ""
        echo -e "૮(„• ⌔ •„)ა📝"

        # Goal check
        read -r -r -p "$(echo -e "${PLUM}Goal: '$GOAL' — Enter to keep, type new, or d to mark complete: ${NC}")" GOAL_INPUT
        if [ "$GOAL_INPUT" = "d" ] || [ "$GOAL_INPUT" = "D" ]; then
            if [ "$TRACK_COMPLETION" = true ]; then
                GOAL_LOG+=("✓ COMPLETED: $GOAL ($(date +"%I:%M %p"))")
                echo -e "${LIME}Goal marked complete.${NC}"
            else
                echo -e "${LIME}Nice work!${NC}"
            fi
            read -r -r -p "$(echo -e "${ORANGE}What's your next goal? (Enter for random): ${NC}")" NEW_GOAL
            GOAL=${NEW_GOAL:-"$(shuf -n 1 "$GOALS_FILE")"}
            GOAL_LOG+=("$GOAL")
        elif [ -n "$GOAL_INPUT" ]; then
            GOAL="$GOAL_INPUT"
            GOAL_LOG+=("$GOAL")
        fi
        echo ""

        # Reminder update
        read -r -r -p "$(echo -e "${PINK}Reminder: '${SESSION_REMINDER:-none}' — Enter to keep, or type new: ${NC}")" NEW_REMINDER
        if [ -n "$NEW_REMINDER" ]; then
            SESSION_REMINDER="$NEW_REMINDER"
            echo -e "${LIME}Reminder updated.${NC}"
        fi
        echo ""

        # Reward — offer to save previous if typed, then set new one
        if [ "$REWARDS_ENABLED" != "off" ]; then
            if [ -n "$ROUND_REWARD" ] && [ "$REWARD_SOURCE" = "typed" ]; then
                read -r -r -p "$(echo -e "${YELLOW}Save '$ROUND_REWARD' to your rewards list? (y/Enter to skip): ${NC}")" SAVE_REWARD
                if [ "$SAVE_REWARD" = "y" ] || [ "$SAVE_REWARD" = "Y" ]; then
                    if [ -n "$ROUND_REWARD" ]; then
                        echo "$ROUND_REWARD" >> "$REWARDS_FILE"
                        echo -e "${LIME}Saved to rewards list.${NC}"
                    fi
                fi
            fi
            echo ""
            echo -e "${YELLOW}Current reward: ${ROUND_REWARD:-none}${NC}"
            read -r -r -p "$(echo -e "${YELLOW}Enter to keep / r for random / type new / s to skip: ${NC}")" REWARD_INPUT
            if [ "$REWARD_INPUT" = "s" ] || [ "$REWARD_INPUT" = "S" ]; then
                ROUND_REWARD=""
                REWARD_SOURCE=""
            elif [ "$REWARD_INPUT" = "r" ] || [ "$REWARD_INPUT" = "R" ]; then
                if [ -f "$REWARDS_FILE" ] && [ -s "$REWARDS_FILE" ]; then
                    ROUND_REWARD=$(shuf -n 1 "$REWARDS_FILE")
                    REWARD_SOURCE="list"
                else
                    echo -e "${GREY}No rewards list found — type one in instead.${NC}"
                    read -r -r -p "$(echo -e "${YELLOW}Your reward: ${NC}")" ROUND_REWARD
                    REWARD_SOURCE="typed"
                fi
            elif [ -n "$REWARD_INPUT" ]; then
                ROUND_REWARD="$REWARD_INPUT"
                REWARD_SOURCE="typed"
            fi
        fi
        echo ""
        read -r -r -p "$(echo -e "${LIME}Press Enter to start focus ${FOCUS_LABEL} $(( i ))...${NC}")" _
    fi

    # ── FOCUS BLOCK ──
    # shellcheck disable=SC2034
    BLOCK_START_EPOCH=$(date +%s)

    echo ""
    echo -e "\a"
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo -e "${SKY}  FOCUS ${FOCUS_LABEL^^} $i of $SESSIONS${NC}"
    echo -e "${SKY}─────────────────────────────────────────${NC}"
    echo ""
    echo -e "${PLUM}  Goal: $GOAL${NC}"
    [ -n "$ROUND_REWARD" ] && echo -e "${YELLOW}  Reward: $ROUND_REWARD${NC}"
    echo ""
    echo -e "Started:${TEAL} $(date +"%I:%M %p")${NC}"
    echo -e "Expected break:${PINK} $(date -d "+${DURATION} minutes" +"%I:%M %p")${NC}"
    echo -e "${GREY}Press Enter at any time to skip to break.${NC}"
    read -r -r -t $(( DURATION * 60 ))
    echo -ne "\r\e[K"

    # Capture buffer time
    BLOCK_END_EPOCH=$(date +%s)
    echo ""
    echo -e "\a"
    read -r -r -p "$(echo -e "${LIME}Focus ${FOCUS_LABEL} complete — press Enter to start break${NC}")" _
    BREAK_ACTUAL_START_EPOCH=$(date +%s)
    BUFFER=$(( BREAK_ACTUAL_START_EPOCH - BLOCK_END_EPOCH ))
    BUFFER_MIN=$(( BUFFER / 60 ))
    BUFFER_SEC=$(( BUFFER % 60 ))
    BUFFER_TIMES+=("Round $i: ${BUFFER_MIN}m ${BUFFER_SEC}s")

    # ── BREAK BLOCK ──
    echo ""
    echo -e "\a"
    echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
    if [ "$i" -eq "$SESSIONS" ]; then
        echo -e "${LAVENDER}  FINAL BREAK${NC}"
        echo ""
        echo -e "૮(„• ⌔ •„)ა⧗"
        echo -e "${PLUM}I recommend taking a 20 minute break after the reflection before trying another session!${NC}"
    else
        echo -e "${LAVENDER}  BREAK — ${BREAK_DURATION} minutes${NC}"
    fi
    echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
    echo ""

    # Reward reveal
    if [ -n "$ROUND_REWARD" ]; then
        RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
        echo -e "૮(„• ⌔ •„)ა🎁"
        echo -e "${RAINBOW_WAY}Congrats — you get your reward: $ROUND_REWARD${NC}"
        echo ""
    fi

    echo -e "Started:${TEAL} $(date +"%I:%M %p")${NC}"
    if [ "$i" -lt "$SESSIONS" ]; then
        echo -e "Back to work:${PINK} $(date -d "+${BREAK_DURATION} minutes" +"%I:%M %p")${NC}"
    fi
    echo ""

    # Session reminder
    if [ -n "$SESSION_REMINDER" ]; then
        RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
        echo -e "૮(„• ⌔ •„)ა📝"
        echo -e "${RAINBOW_WAY}★ Don't forget: $SESSION_REMINDER${NC}"
        echo ""
    fi

    # Break content
    BREAK_CONTENT=(
        "$(shuf -n 1 "$EXERCISES_FILE")"
        "$(shuf -n 1 "$AUTO_NUDGES_FILE")"
        "$(shuf -n 1 "$EXERCISES_FILE")"
        "$(shuf -n 1 "$AUTO_NUDGES_FILE")"
        "$(shuf -n 1 "$EXERCISES_FILE")"
        "$(shuf -n 1 "$AUTO_NUDGES_FILE")"
    )

    RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
    echo -e "${RAINBOW_WAY}${BREAK_CONTENT[0]}${NC}"

    REMAINING=$BREAK_DURATION
    INDEX=1
    COLOR_INDEX=0

    while [ "$REMAINING" -gt 1 ]; do
        echo ""
        read -r -r -t 60 -p "$(echo -e "${GREY}(press Enter to skip break)${NC}")" _
        echo ""

        REMAINING=$(( REMAINING - 1 ))
        CONTENT_INDEX=$(( INDEX % ${#BREAK_CONTENT[@]} ))
        CURRENT_COLOR=${TRAFFIC[$COLOR_INDEX]}

        RAINBOW_WAY=${RAINBOW_CONNECTION[$((RANDOM % ${#RAINBOW_CONNECTION[@]}))]}
        echo ""
        echo -e "${RAINBOW_WAY}${BREAK_CONTENT[$CONTENT_INDEX]}${NC}"
        echo -e "${CURRENT_COLOR}$REMAINING minute(s) remaining${NC}"

        if [ $COLOR_INDEX -lt $(( ${#TRAFFIC[@]} - 1 )) ]; then
            COLOR_INDEX=$(( COLOR_INDEX + 1 ))
        fi
        INDEX=$(( INDEX + 1 ))
    done

    # Final break minute
    echo ""
    if [ "$i" -eq "$SESSIONS" ]; then
        read -r -t 60 -p "$(echo -e "${GREY}(press Enter to skip to reflection)${NC}")" _
    else
        read -r -t 60 -p "$(echo -e "${GREY}(press Enter to skip to next ${FOCUS_LABEL})${NC}")" _
    fi

    echo -e "\a"

    # End of break reflection
    if [ "$BREAK_REFLECTION" = "ask" ] || [ "$BREAK_REFLECTION" = "always" ]; then
        if [ -f "$BREAK_Q_FILE" ] && [ -s "$BREAK_Q_FILE" ]; then
            echo ""
            BREAK_Q=$(shuf -n 1 "$BREAK_Q_FILE")
            read -r -p "$(echo -e "${ORANGE}$BREAK_Q ${NC}")" BREAK_A
            if [ -n "$BREAK_A" ]; then
                BREAK_ANSWERS+=("Break $i: $BREAK_A")
                echo ""
                read -r -p "$(echo -e "${LIME}Add that to your nudges list? (y/Enter to skip): ${NC}")" SAVE_NUDGE
                if [ "$SAVE_NUDGE" = "y" ] || [ "$SAVE_NUDGE" = "Y" ]; then
                    echo "$BREAK_A" >> "$AUTO_NUDGES_FILE"
                    echo -e "${LIME}Added to nudges.${NC}"
                fi
            fi
        fi
    fi

done

# ── END BLOCK ──

echo ""
# ── END BLOCK ──

echo ""
echo -e "\a"
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo -e "${PLUM}  SESSION COMPLETE${NC}"
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა⯎"
echo ""
echo -e "${LIME}$SESSIONS focus ${FOCUS_LABEL}s complete. Nice work.${NC}"
echo -e "${TEAL}Started:  $SESSION_START${NC}"
echo -e "${PINK}Finished: $(date +"%I:%M %p")${NC}"
echo ""

# Reflection question
REFLECTION_Q=$(shuf -n 1 "$SESSION_Q_FILE")
read -r -p "$(echo -e "${ORANGE}Reflection: $REFLECTION_Q ${NC}")" REFLECTION_A
echo ""

# Buffer review
if [ "$BUFFER_REVIEW" = "ask" ] || [ "$BUFFER_REVIEW" = "always" ]; then
    if [ ${#BUFFER_TIMES[@]} -gt 0 ]; then
        read -r -p "$(echo -e "${LAVENDER}Want to review your wrap-up buffer times? (y/Enter to skip): ${NC}")" REVIEW_INPUT
        if [ "$REVIEW_INPUT" = "y" ] || [ "$REVIEW_INPUT" = "Y" ]; then
            echo ""
            echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
            echo -e "${LAVENDER}  WRAP-UP BUFFER TIMES${NC}"
            echo -e "${LAVENDER}─────────────────────────────────────────${NC}"
            for entry in "${BUFFER_TIMES[@]}"; do
                echo -e "${GREY}  $entry${NC}"
            done
            echo ""
            read -r -p "$(echo -e "${LAVENDER}Save buffer times to log with a note? (Enter to skip, or type note): ${NC}")" BUFFER_NOTE
        fi
    fi
fi

# Win prompt
echo ""
read -r -p "$(echo -e "${YELLOW}One win from this session — keep it to one sentence. (Enter to skip): ${NC}")" WIN
if [ -n "$WIN" ]; then
    echo "$WIN" >> "$AUTO_WINS_FILE"
    echo -e "${LIME}Saved to wins list.${NC}"
fi

# Big break reward prompt
echo ""
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა⧗"
read -r -p "$(echo -e "${PLUM}Want to take a big break before your next session? (y/Enter to skip): ${NC}")" BIG_BREAK_INPUT
if [ "$BIG_BREAK_INPUT" = "y" ] || [ "$BIG_BREAK_INPUT" = "Y" ]; then
    echo ""
    echo -e "${LAVENDER}  BIG BREAK — ${BIG_BREAK} minutes${NC}"
    echo -e "Started:${TEAL} $(date +"%I:%M %p")${NC}"
    echo -e "Back at it:${PINK} $(date -d "+${BIG_BREAK} minutes" +"%I:%M %p")${NC}"
    echo ""
    echo -e "${PLUM}You earned it. See you on the other side.${NC}"
    echo ""
    read -r -t $(( BIG_BREAK * 60 )) -p "$(echo -e "${GREY}(press Enter to end big break early)${NC}")" _
    echo -ne "\r\e[K"
    echo ""
    echo -e "\a"
    echo -e "${LIME}Big break complete. Welcome back.${NC}"
fi

# ── SESSION LOG ──
SESSION_END=$(date +"%I:%M %p")
{
    echo "## $(date +"%Y-%m-%d") — $SESSION_END"
    echo ""
    echo "- **Focus ${FOCUS_LABEL}s completed:** $SESSIONS"
    echo "- **Started:** $SESSION_START"
    echo "- **Finished:** $SESSION_END"
    echo ""
    echo "- **Goals:**"
    for g in "${GOAL_LOG[@]}"; do
        echo "  - $g"
    done
    echo ""
    if [ -n "$ROUND_REWARD" ] || [ ${#BUFFER_TIMES[@]} -gt 0 ]; then
        [ -n "$ROUND_REWARD" ] && echo "- **Final reward:** $ROUND_REWARD"
        echo ""
    fi
    if [ "$TRACK_COMPLETION" = true ]; then
        COMPLETED_COUNT=$(grep -c "✓ COMPLETED" <<< "$(printf '%s\n' "${GOAL_LOG[@]}")" 2>/dev/null || echo 0)
        echo "- **Goals completed:** $COMPLETED_COUNT"
        echo ""
    fi
    if [ -n "$BUFFER_NOTE" ]; then
        echo "- **Wrap-up buffer:**"
        for entry in "${BUFFER_TIMES[@]}"; do
            echo "  - $entry"
        done
        [ -n "$BUFFER_NOTE" ] && echo "  - Note: $BUFFER_NOTE"
        echo ""
    fi
    if [ ${#BREAK_ANSWERS[@]} -gt 0 ]; then
        echo "- **Break reflections:**"
        for a in "${BREAK_ANSWERS[@]}"; do
            echo "  - $a"
        done
        echo ""
    fi
    echo "- **Reflection:** $REFLECTION_Q"
    echo "  - $REFLECTION_A"
    [ -n "$WIN" ] && echo "- **Win:** $WIN"
    echo ""
    echo "---"
    echo ""
} >> "$LOG_FILE"

echo ""
echo -e "૮(„• ⌔ •„)ა📝"
echo -e "${SKY}Session logged.${NC}"
echo ""