#!/bin/bash

# ─────────────────────────────────────────
#  ACCOUNTABILI-BUDDY — Updater
# v1.1.2
#  update.sh
# ─────────────────────────────────────────

UPDATER_VERSION="1.1.2"

NC=$'\e[0m'
PLUM=$'\e[38;5;13m'
SKY=$'\e[38;5;45m'
LIME=$'\e[38;5;106m'
TEAL=$'\e[38;5;43m'
YELLOW=$'\e[38;5;220m'
GREY=$'\e[38;5;60m'
PINK=$'\e[38;5;219m'
#ORANGE=$'\e[38;5;214m'
LAVENDER=$'\e[38;5;141m'

# ── FIND CONFIG ──
CONFIG="${1:-$HOME/.abuddy/abuddy.cfg}"

if [ ! -f "$CONFIG" ]; then
    echo ""
    echo -e "${PINK}No abuddy config found at $CONFIG${NC}"
    echo -e "${PINK}Looks like abuddy isn't installed yet — or was installed to a custom path.${NC}"
    echo ""
    echo -e "${PLUM}Run install.sh first, or point update.sh at your config:${NC}"
    echo -e "${TEAL}  bash install.sh${NC}"
    echo -e "${TEAL}  bash update.sh ~/.myabuddy/abuddy.cfg${NC}"
    echo ""
    exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG"

# ── INTRO ──
echo ""
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo -e "${PLUM}  ACCOUNTABILI-BUDDY UPDATER${NC}"
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა🔧"
echo ""
echo -e "${PLUM}Hi! Let's get you up to date.${NC}"
echo ""
echo -e "${GREY}Installed version: ${ABUDDY_VERSION:-unknown}${NC}"
echo -e "${GREY}Updater version:   $UPDATER_VERSION${NC}"
echo ""

# ── STEP 1 — COPY SCRIPT IF NEWER ──
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  STEP 1 OF 3 — SCRIPT${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""

SCRIPT_SOURCE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/abuddy.sh"

if [ ! -f "$SCRIPT_SOURCE" ]; then
    echo -e "${PINK}Could not find abuddy.sh in the same directory as update.sh.${NC}"
    echo -e "${PINK}Make sure you're running update.sh from the repo folder.${NC}"
    echo ""
    exit 1
fi

if [ "${ABUDDY_VERSION:-0}" = "$UPDATER_VERSION" ]; then
    echo -e "${LIME}Script is already at v$UPDATER_VERSION — nothing to copy.${NC}"
else
    cp "$SCRIPT_SOURCE" "$ABUDDY_DIR/abuddy.sh"
    chmod 700 "$ABUDDY_DIR/abuddy.sh"
    echo -e "${LIME}Updated: $ABUDDY_DIR/abuddy.sh${NC}"
    echo -e "${GREY}  ${ABUDDY_VERSION:-unknown} → $UPDATER_VERSION${NC}"

    # Update version in config
    sed -i "s/^ABUDDY_VERSION=.*/ABUDDY_VERSION=\"$UPDATER_VERSION\"/" "$CONFIG"
    echo -e "${LIME}Config version bumped to $UPDATER_VERSION${NC}"
fi
echo ""
read -r -p "$(echo -e "${LIME}Press Enter to continue (Step 2 of 3)...${NC}")" _

# ── STEP 2 — CHECK CONFIG KEYS AND LIST FILES ──
echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  STEP 2 OF 3 — CONFIG AND FILES${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა📝"
echo -e "${PLUM}Checking for missing config keys and list files...${NC}"
echo ""

CHANGES_MADE=false

# ── MISSING CONFIG KEYS ──
# Each key: check if present in config, append with default if missing

add_key_if_missing() {
    local KEY="$1"
    local DEFAULT="$2"
    local COMMENT="$3"
    if ! grep -q "^${KEY}=" "$CONFIG"; then
        echo "" >> "$CONFIG"
        [ -n "$COMMENT" ] && echo "# $COMMENT" >> "$CONFIG"
        echo "${KEY}=${DEFAULT}" >> "$CONFIG"
        echo -e "${YELLOW}Added missing key: ${KEY}=${DEFAULT}${NC}"
        CHANGES_MADE=true
    fi
}
# shellcheck disable=SC2016
add_key_if_missing "BIG_BREAK"            "20"    "big break duration in minutes"
add_key_if_missing "FOCUS_NAME"          "Focus Round" "what a single work period is called"
add_key_if_missing "ALERT_MODE"           "both"  "both / sound / flash / silent"
add_key_if_missing "REWARDS_ENABLED"      "ask"   "ask / always / off"
add_key_if_missing "COMPLETION_TRACKING"  "ask"   "ask / always / off"
add_key_if_missing "BUFFER_REVIEW"        "ask"   "ask / always / off"
add_key_if_missing "BREAK_REFLECTION"     "ask"   "ask / always / off"
# shellcheck disable=SC2016
add_key_if_missing "AUTO_REWARDS_FILE"         '"\$ABUDDY_DIR/auto-rewards.txt"'       ""
# shellcheck disable=SC2016
add_key_if_missing "SESSION_Q_FILE"       '"\$ABUDDY_DIR/session-q.txt"'     ""
# shellcheck disable=SC2016
add_key_if_missing "BREAK_Q_FILE"         '"\$ABUDDY_DIR/break-q.txt"'       ""
# shellcheck disable=SC2016
add_key_if_missing "AUTO_NUDGES_FILE"     '"\$ABUDDY_DIR/auto-nudges.txt"'   ""
# shellcheck disable=SC2016
add_key_if_missing "AUTO_WINS_FILE"       '"\$ABUDDY_DIR/auto-wins.txt"'     ""
# shellcheck disable=SC2016
add_key_if_missing "QUOTES_FILE"          '"\$ABUDDY_DIR/quotes.txt"'        ""

# ── MISSING LIST FILES ──
# Only creates if missing — never overwrites existing content

create_if_missing() {
    local FILE="$1"
    shift 2
    if [ ! -f "$FILE" ]; then
        cat > "$FILE" << EOF
$@
EOF
        chmod 600 "$FILE"
        echo -e "${YELLOW}Created missing file: $FILE${NC}"
        CHANGES_MADE=true
    fi
}

# Manual files
if [ ! -f "${ABUDDY_DIR}/auto-rewards.txt" ]; then
    cat > "${ABUDDY_DIR}/auto-rewards.txt" << 'EOF'
a hot drink and five minutes outside
your favourite snack
a short walk around the block
ten minutes of a show or video
a chapter of whatever you're reading
a stretch and some fresh air
EOF
    chmod 600 "${ABUDDY_DIR}/auto-rewards.txt"
    echo -e "${YELLOW}Created missing file: ${ABUDDY_DIR}/auto-rewards.txt${NC}"
    CHANGES_MADE=true
fi

if [ ! -f "${ABUDDY_DIR}/session-q.txt" ]; then
    cat > "${ABUDDY_DIR}/session-q.txt" << 'EOF'
What went well this session?
What would you do differently next time?
What's one thing you actually learned today?
What's still on your mind that you haven't dealt with yet?
What are you proud of from today?
EOF
    chmod 600 "${ABUDDY_DIR}/session-q.txt"
    echo -e "${YELLOW}Created missing file: ${ABUDDY_DIR}/session-q.txt${NC}"
    CHANGES_MADE=true
fi

if [ ! -f "${ABUDDY_DIR}/break-q.txt" ]; then
    cat > "${ABUDDY_DIR}/break-q.txt" << 'EOF'
What did you do on your break?
Did anything on your break re-energize you?
What's one thing you noticed during your break?
Did you move around? How does your body feel?
What are you bringing back to your desk?
Did anything helpful happen on your break?
EOF
    chmod 600 "${ABUDDY_DIR}/break-q.txt"
    echo -e "${YELLOW}Created missing file: ${ABUDDY_DIR}/break-q.txt${NC}"
    CHANGES_MADE=true
fi

if [ ! -f "${ABUDDY_DIR}/quotes.txt" ]; then
    cat > "${ABUDDY_DIR}/quotes.txt" << 'EOF'
Add your favourite motivational quotes here, one per line.
EOF
    chmod 600 "${ABUDDY_DIR}/quotes.txt"
    echo -e "${YELLOW}Created missing file: ${ABUDDY_DIR}/quotes.txt${NC}"
    CHANGES_MADE=true
fi

# Auto files — only create if missing, never overwrite
if [ ! -f "${ABUDDY_DIR}/auto-nudges.txt" ]; then
    cat > "${ABUDDY_DIR}/auto-nudges.txt" << 'EOF'
How's your posture right now?
Have you had water recently?
Take three slow breaths before the next session
Blink a few times and look at something across the room
Check in — how are you actually feeling?
You're doing the thing. That counts.
EOF
    chmod 600 "${ABUDDY_DIR}/auto-nudges.txt"
    echo -e "${YELLOW}Created missing file: ${ABUDDY_DIR}/auto-nudges.txt${NC}"
    CHANGES_MADE=true
fi

if [ ! -f "${ABUDDY_DIR}/auto-wins.txt" ]; then
    cat > "${ABUDDY_DIR}/auto-wins.txt" << 'EOF'
You installed abuddy. That's a win.
You showed up. Seriously, that matters.
You're building something. Keep going.
EOF
    chmod 600 "${ABUDDY_DIR}/auto-wins.txt"
    echo -e "${YELLOW}Created missing file: ${ABUDDY_DIR}/auto-wins.txt${NC}"
    CHANGES_MADE=true
fi

if [ "$CHANGES_MADE" = false ]; then
    echo -e "${LIME}Everything looks good — no missing keys or files.${NC}"
fi

echo ""
read -r -p "$(echo -e "${LIME}Press Enter to continue (Step 3 of 3)...${NC}")" _

# ── STEP 3 — CONFIG EDITOR ──
echo ""
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo -e "${SKY}  STEP 3 OF 3 — SETTINGS${NC}"
echo -e "${SKY}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა⚙"
echo -e "${PLUM}Let's walk through your settings.${NC}"
echo -e "${PLUM}Press Enter to keep the current value,${NC}"
echo -e "${PLUM}or type a new one.${NC}"
echo ""

update_config_key() {
    local KEY="$1"
    local CURRENT="$2"
    local PROMPT="$3"
    local OPTIONS="$4"
    echo -e "${GREY}$OPTIONS${NC}"
    read -r -p "$(echo -e "${PLUM}$PROMPT ${TEAL}(current: $CURRENT)${PLUM}: ${NC}")" NEW_VAL
    if [ -n "$NEW_VAL" ] && [ "$NEW_VAL" != "$CURRENT" ]; then
        sed -i "s/^${KEY}=.*/${KEY}=${NEW_VAL}/" "$CONFIG"
        echo -e "${LIME}Updated: ${KEY}=${NEW_VAL}${NC}"
    else
        echo -e "${GREY}Kept: ${KEY}=${CURRENT}${NC}"
    fi
    echo ""
}

# Re-source config to get current values after step 2 additions
# shellcheck source=/dev/null
source "$CONFIG"

echo -e "${LAVENDER}── TIMER DEFAULTS ───────────────────────────${NC}"
echo ""
update_config_key "DEFAULT_WORK"     "$DEFAULT_WORK"     "Work duration in minutes"     ""
update_config_key "DEFAULT_BREAK"    "$DEFAULT_BREAK"    "Break duration in minutes"    ""
update_config_key "DEFAULT_SESSIONS" "$DEFAULT_SESSIONS" "Number of focus rounds"       ""
update_config_key "BIG_BREAK"        "$BIG_BREAK"        "Big break duration in minutes" ""

echo -e "${LAVENDER}── LABEL ────────────────────────────────────${NC}"
echo ""
update_config_key "FOCUS_NAME" "$FOCUS_NAME" "What to call a single work period" \
    "Examples: Focus round, Deep work, Pomodoro — full name"

echo -e "${LAVENDER}── ALERT ────────────────────────────────────${NC}"
echo ""
update_config_key "ALERT_MODE" "$ALERT_MODE" "Alert style at transitions" \
    "Options: both / sound / flash / silent"

echo -e "${LAVENDER}── TOGGLES ──────────────────────────────────${NC}"
echo ""
update_config_key "REWARDS_ENABLED"     "$REWARDS_ENABLED"     "Reward system" \
    "Options: ask / always / off"
update_config_key "COMPLETION_TRACKING" "$COMPLETION_TRACKING" "Goal completion tracking" \
    "Options: ask / always / off"
update_config_key "BUFFER_REVIEW"       "$BUFFER_REVIEW"       "Wrap-up buffer review at reflection" \
    "Options: ask / always / off"
update_config_key "BREAK_REFLECTION"    "$BREAK_REFLECTION"    "End of break reflection question" \
    "Options: ask / always / off"

# ── SUMMARY ──
echo ""
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo -e "${PLUM}  ALL DONE${NC}"
echo -e "${PLUM}─────────────────────────────────────────${NC}"
echo ""
echo -e "૮(„• ⌔ •„)ა[✓]"
echo ""
echo -e "${LIME}Config: $CONFIG${NC}"
echo -e "${LIME}Script: $ABUDDY_DIR/abuddy.sh${NC}"
echo ""
echo -e "${PLUM}Run abuddy any time with:${NC}"
echo -e "${TEAL}  abuddy${NC}"
echo -e "${GREY}  (or bash $ABUDDY_DIR/abuddy.sh if alias isn't set)${NC}"
echo ""
echo -e "✦ ૮(„^ ⌔ ^„)ა✦"
echo ""