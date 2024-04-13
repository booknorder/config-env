#!/usr/bin/env bash
#** Notes
#-➤ Source: https://github.com/fidian/ansi/blob/master/ansi
#-➤ Modified: Functions with '::' replaced with '_'
#-➤ Modified: See the very end section (Additions)

#>= Original
#-----------------------------------------------------------------------------
# ANSI code generator
# Licensed under the MIT license with an additional non-advertising clause
# See http://github.com/fidian/ansi
# © Copyright 2015 Tyler Akins

ANSI_ESC=$'\033'
ANSI_CSI="${ANSI_ESC}["
ANSI_OSC="${ANSI_ESC}]"
ANSI_ST="${ANSI_ESC}\\"
ANSI_REPORT="" # The return value from ansi_report

ansi_backward() {
  printf '%s%sD' "$ANSI_CSI" "${1-}"
}

ansi_bell() {
  printf "%s" $'\007'
}

ansi_black() {
  printf '%s30m' "$ANSI_CSI"
}

ansi_blackIntense() {
  printf '%s90m' "$ANSI_CSI"
}

ansi_blink() {
  printf '%s5m' "$ANSI_CSI"
}

ansi_blue() {
  printf '%s34m' "$ANSI_CSI"
}

ansi_blueIntense() {
  printf '%s94m' "$ANSI_CSI"
}

ansi_bgBlack() {
  printf '%s40m' "$ANSI_CSI"
}

ansi_bgBlackIntense() {
  printf '%s100m' "$ANSI_CSI"
}

ansi_bgBlue() {
  printf '%s44m' "$ANSI_CSI"
}

ansi_bgBlueIntense() {
  printf '%s104m' "$ANSI_CSI"
}

ansi_bgColor() {
  printf '%s48;5;%sm' "$ANSI_CSI" "$1"
}

ansi_bgCyan() {
  printf '%s46m' "$ANSI_CSI"
}

ansi_bgCyanIntense() {
  printf '%s106m' "$ANSI_CSI"
}

ansi_bgGreen() {
  printf '%s42m' "$ANSI_CSI"
}

ansi_bgGreenIntense() {
  printf '%s102m' "$ANSI_CSI"
}

ansi_bgMagenta() {
  printf '%s45m' "$ANSI_CSI"
}

ansi_bgMagentaIntense() {
  printf '%s105m' "$ANSI_CSI"
}

ansi_bgRed() {
  printf '%s41m' "$ANSI_CSI"
}

ansi_bgRgb() {
  printf '%s48;2;%s;%s;%sm' "$ANSI_CSI" "$1" "$2" "$3"
}

ansi_bgRedIntense() {
  printf '%s101m' "$ANSI_CSI"
}

ansi_bgWhite() {
  printf '%s47m' "$ANSI_CSI"
}

ansi_bgWhiteIntense() {
  printf '%s107m' "$ANSI_CSI"
}

ansi_bgYellow() {
  printf '%s43m' "$ANSI_CSI"
}

ansi_bgYellowIntense() {
  printf '%s103m' "$ANSI_CSI"
}

ansi_bold() {
  printf '%s1m' "$ANSI_CSI"
}

ansi_color() {
  printf '%s38;5;%sm' "$ANSI_CSI" "$1"
}

ansi_colorCodes() {
  local code i j

  printf 'Standard: '
  ansi_bold
  ansi_white

  for code in 0 1 2 3 4 5 6 7; do
    if [[ "$code" == 7 ]]; then
      ansi_black
    fi
    ansi_colorCodePatch "$code"
  done

  ansi_resetForeground
  ansi_normal
  printf '\nIntense:  '
  ansi_white

  for code in 8 9 10 11 12 13 14 15; do
    if [[ "$code" == 9 ]]; then
      ansi_black
    fi
    ansi_colorCodePatch "$code"
  done

  ansi_resetForeground
  printf '\n\n'

  # for i in 16 22 28 34 40 46; do
  for i in 16 22 28; do
    for j in $i $((i + 36)) $((i + 72)) $((i + 108)) $((i + 144)) $((i + 180)); do
      ansi_white
      ansi_bold

      for code in $j $((j + 1)) $((j + 2)) $((j + 3)) $((j + 4)) $((j + 5)); do
        ansi_colorCodePatch "$code"
      done

      ansi_normal
      ansi_resetForeground
      printf '    '
      ansi_black

      for code in $((j + 18)) $((j + 19)) $((j + 20)) $((j + 21)) $((j + 22)) $((j + 23)); do
        ansi_colorCodePatch "$code"
      done

      ansi_resetForeground
      printf '\n'
    done

    printf '\n'
  done

  printf 'Grays:    '
  ansi_bold
  ansi_white

  for code in 232 233 234 235 236 237 238 239 240 241 242 243; do
    ansi_colorCodePatch "$code"
  done

  ansi_resetForeground
  ansi_normal
  printf '\n          '
  ansi_black

  for code in 244 245 246 247 248 249 250 251 252 253 254 255; do
    ansi_colorCodePatch "$code"
  done

  ansi_resetForeground
  printf '\n'
}

ansi_colorCodePatch() {
  ansi_bgColor "$1"
  printf ' %3s ' "$1"
  ansi_resetBackground
}

ansi_colorTable() {
  local colorLabel counter fnbLower fnbUpper functionName IFS resetFunction

  fnbLower="$(
    ansi_faint
    printf f
    ansi_normal
    printf n
    ansi_bold
    printf b
    ansi_normal
  )"
  fnbUpper="$(
    ansi_faint
    printf F
    ansi_normal
    printf N
    ansi_bold
    printf B
    ansi_normal
  )"
  IFS=$' \n'
  counter=

  while read -r colorLabel functionName resetFunction; do
    printf -- '--%s ' "$colorLabel"
    $functionName
    printf 'Sample'
    $resetFunction

    if [[ "$counter" == "x" ]]; then
      counter=
      printf '\n'
    else
      counter=x
      ansi_column 40
    fi
  done <<END
bold ansi_bold ansi_normal
faint ansi_faint ansi_normal
italic ansi_italic ansi_plain
fraktur ansi_fraktur ansi_plain
underline ansi_underline ansi_noUnderline
double-underline ansi_doubleUnderline ansi_noUnderline
blink ansi_blink ansi_noBlink
rapid-blink ansi_rapidBlink ansi_noBlink
inverse ansi_inverse ansi_noInverse
invisible ansi_invisible ansi_visible
strike ansi_strike ansi_noStrike
frame ansi_frame ansi_noBorder
encircle ansi_encircle ansi_noBorder
overline ansi_overline ansi_noOverline
ideogram-right ansi_ideogramRight ansi_resetIdeogram
ideogram-right-double ansi_ideogramRightDouble ansi_resetIdeogram
ideogram-left ansi_ideogramLeft ansi_resetIdeogram
ideogram-left-double ansi_ideogramLeftDouble ansi_resetIdeogram
ideogram-stress ansi_ideogramStress ansi_resetIdeogram
END

  if [[ -n "$counter" ]]; then
    printf '\n'
  fi
  printf '\n'
  printf '            black   red   green  yellow  blue  magenta cyan  white\n'
  ansi_colorTableLine "(none)" "ansi_resetBackground" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-black" "ansi_bgBlack" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgBlackIntense" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-red" "ansi_bgRed" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgRedIntense" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-green" "ansi_bgGreen" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgGreenIntense" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-yellow" "ansi_bgYellow" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgYellowIntense" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-blue" "ansi_bgBlue" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgBlueIntense" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-magenta" "ansi_bgMagenta" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgMagentaIntense" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-cyan" "ansi_bgCyan" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgCyanIntense" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "bg-white" "ansi_bgWhite" "$fnbLower" "$fnbUpper"
  ansi_colorTableLine "+ intense" "ansi_bgWhiteIntense" "$fnbLower" "$fnbUpper"

  printf '\n'
  printf 'Legend:\n'
  printf '    Normal color:  f = faint, n = normal, b = bold.\n'
  printf '    Intense color:  F = faint, N = normal, B = bold.\n'
}

ansi_colorTableLine() {
  local fn

  printf '%-12s' "$1"
  for fn in ansi_black ansi_red ansi_green ansi_yellow ansi_blue ansi_magenta ansi_cyan ansi_white; do
    $2
    ${fn}
    printf '%s' "$3"
    ${fn}Intense
    printf '%s' "$4"
    ansi_resetForeground
    ansi_resetBackground

    if [[ "$fn" != "ansi_white" ]]; then
      printf ' '
    fi
  done
  printf '\n'
}

ansi_column() {
  printf '%s%sG' "$ANSI_CSI" "${1-}"
}

ansi_columnRelative() {
  printf '%s%sa' "$ANSI_CSI" "${1-}"
}

ansi_cyan() {
  printf '%s36m' "$ANSI_CSI"
}

ansi_cyanIntense() {
  printf '%s96m' "$ANSI_CSI"
}

ansi_deleteChars() {
  printf '%s%sP' "$ANSI_CSI" "${1-}"
}

ansi_deleteLines() {
  printf '%s%sM' "$ANSI_CSI" "${1-}"
}

ansi_doubleUnderline() {
  printf '%s21m' "$ANSI_CSI"
}

ansi_down() {
  printf '%s%sB' "$ANSI_CSI" "${1-}"
}

ansi_encircle() {
  printf '%s52m' "$ANSI_CSI"
}

ansi_eraseDisplay() {
  printf '%s%sJ' "$ANSI_CSI" "${1-}"
}

ansi_eraseChars() {
  printf '%s%sX' "$ANSI_CSI" "${1-}"
}

ansi_eraseLine() {
  printf '%s%sK' "$ANSI_CSI" "${1-}"
}

ansi_faint() {
  printf '%s2m' "$ANSI_CSI"
}

ansi_font() {
  printf '%s1%sm' "$ANSI_CSI" "${1-0}"
}

ansi_forward() {
  printf '%s%sC' "$ANSI_CSI" "${1-}"
}

ansi_fraktur() {
  printf '%s20m' "$ANSI_CSI"
}

ansi_frame() {
  printf '%s51m' "$ANSI_CSI"
}

ansi_green() {
  printf '%s32m' "$ANSI_CSI"
}

ansi_greenIntense() {
  printf '%s92m' "$ANSI_CSI"
}

ansi_hideCursor() {
  printf '%s?25l' "$ANSI_CSI"
}

ansi_ideogramLeft() {
  printf '%s62m' "$ANSI_CSI"
}

ansi_ideogramLeftDouble() {
  printf '%s63m' "$ANSI_CSI"
}

ansi_ideogramRight() {
  printf '%s60m' "$ANSI_CSI"
}

ansi_ideogramRightDouble() {
  printf '%s61m' "$ANSI_CSI"
}

ansi_ideogramStress() {
  printf '%s64m' "$ANSI_CSI"
}

ansi_insertChars() {
  printf '%s%s@' "$ANSI_CSI" "${1-}"
}

ansi_insertLines() {
  printf '%s%sL' "$ANSI_CSI" "${1-}"
}

ansi_inverse() {
  printf '%s7m' "$ANSI_CSI"
}

ansi_invisible() {
  printf '%s8m' "$ANSI_CSI"
}

ansi_isAnsiSupported() {
  # Optionally override detection logic
  # to support post processors that interpret color codes _after_ output is generated.
  # Use environment variable "ANSI_FORCE_SUPPORT=<anything>" to enable the override.
  if [[ -n "${ANSI_FORCE_SUPPORT-}" ]]; then
    return 0
  fi

  if hash tput &>/dev/null; then
    if [[ "$(tput colors)" -lt 8 ]]; then
      return 1
    fi

    return 0
  fi

  # Query the console and see if we get ANSI codes back.
  # CSI 0 c == CSI c == Primary Device Attributes.
  # Idea:  CSI c
  # Response = CSI ? 6 [234] ; 2 2 c
  # The "22" means ANSI color, but terminals don't need to send that back.
  # If we get anything back, let's assume it works.
  ansi_report c "$ANSI_CSI?" c || return 1
  [[ -n "$ANSI_REPORT" ]]
}

ansi_italic() {
  printf '%s3m' "$ANSI_CSI"
}

ansi_line() {
  printf '%s%sd' "$ANSI_CSI" "${1-}"
}

ansi_lineRelative() {
  printf '%s%se' "$ANSI_CSI" "${1-}"
}

ansi_magenta() {
  printf '%s35m' "$ANSI_CSI"
}

ansi_magentaIntense() {
  printf '%s95m' "$ANSI_CSI"
}

ansi_nextLine() {
  printf '%s%sE' "$ANSI_CSI" "${1-}"
}

ansi_noBlink() {
  printf '%s25m' "$ANSI_CSI"
}

ansi_noBorder() {
  printf '%s54m' "$ANSI_CSI"
}

ansi_noInverse() {
  printf '%s27m' "$ANSI_CSI"
}

ansi_normal() {
  printf '%s22m' "$ANSI_CSI"
}

ansi_noOverline() {
  printf '%s55m' "$ANSI_CSI"
}

ansi_noStrike() {
  printf '%s29m' "$ANSI_CSI"
}

ansi_noUnderline() {
  printf '%s24m' "$ANSI_CSI"
}

ansi_overline() {
  printf '%s53m' "$ANSI_CSI"
}

ansi_plain() {
  printf '%s23m' "$ANSI_CSI"
}

ansi_position() {
  local position="${1-}"
  printf '%s%sH' "$ANSI_CSI" "${position/,/;}"
}

ansi_previousLine() {
  printf '%s%sF' "$ANSI_CSI" "${1-}"
}

ansi_rapidBlink() {
  printf '%s6m' "$ANSI_CSI"
}

ansi_red() {
  printf '%s31m' "$ANSI_CSI"
}

ansi_redIntense() {
  printf '%s91m' "$ANSI_CSI"
}

ansi_repeat() {
  printf '%s%sb' "$ANSI_CSI" "${1-}"
}

ansi_report() {
  local buff c report

  report=""

  # Note: read bypass piping, which lets this work:
  # ansi --report-window-chars | cut -d , -f 1
  read -p "$ANSI_CSI$1" -r -N "${#2}" -s -t 1 buff

  if [ "$buff" != "$2" ]; then
    return 1
  fi

  read -r -N "${#3}" -s -t 1 buff

  while [[ "$buff" != "$3" ]]; do
    report="$report${buff:0:1}"
    read -r -N 1 -s -t 1 c || exit 1
    buff="${buff:1}$c"
  done

  ANSI_REPORT=$report
}

ansi_reportPosition() {
  ansi_report 6n "$ANSI_CSI" R || return 1
  printf '%s\n' "${ANSI_REPORT//;/,}"
}

ansi_reportIcon() {
  ansi_report 20t "${ANSI_OSC}L" "$ANSI_ST" || return 1
  printf '%s\n' "${ANSI_REPORT//;/,}"
}

ansi_reportScreenChars() {
  ansi_report 19t "${ANSI_CSI}9;" t || return 1
  printf '%s\n' "${ANSI_REPORT//;/,}"
}

ansi_reportTitle() {
  ansi_report 21t "${ANSI_OSC}l" "$ANSI_ST" || return 1
  printf '%s\n' "${ANSI_REPORT//;/,}"
}

ansi_reportWindowChars() {
  ansi_report 18t "${ANSI_CSI}8;" t || return 1
  printf '%s\n' "${ANSI_REPORT//;/,}"
}

ansi_reportWindowPixels() {
  ansi_report 14t "${ANSI_CSI}4;" t || return 1
  printf '%s\n' "${ANSI_REPORT//;/,}"
}

ansi_reportWindowPosition() {
  ansi_report 13t "${ANSI_CSI}3;" t || return 1
  printf '%s\n' "${ANSI_REPORT//;/,}"
}

ansi_reportWindowState() {
  ansi_report 11t "$ANSI_CSI" t || return 1
  case "$ANSI_REPORT" in
  1)
    printf 'open\n'
    ;;

  2)
    printf 'iconified\n'
    ;;

  *)
    printf 'unknown (%s)\n' "$ANSI_REPORT"
    ;;
  esac
}

ansi_reset() {
  ansi_resetColor
  ansi_resetFont
  ansi_eraseDisplay 2
  ansi_position "1;1"
  ansi_showCursor
}

ansi_resetAttributes() {
  printf '%s22;23;24;25;27;28;29;54;55m' "$ANSI_CSI"
}

ansi_resetBackground() {
  printf '%s49m' "$ANSI_CSI"
}

ansi_resetColor() {
  printf '%s0m' "$ANSI_CSI"
}

ansi_resetFont() {
  printf '%s10m' "$ANSI_CSI"
}

ansi_resetForeground() {
  printf '%s39m' "$ANSI_CSI"
}

ansi_resetIdeogram() {
  printf '%s65m' "$ANSI_CSI"
}

ansi_restoreCursor() {
  printf '%su' "$ANSI_CSI"
}

ansi_rgb() {
  printf '%s38;2;%s;%s;%sm' "$ANSI_CSI" "$1" "$2" "$3"
}

ansi_saveCursor() {
  printf '%ss' "$ANSI_CSI"
}

ansi_scrollDown() {
  printf '%s%sT' "$ANSI_CSI" "${1-}"
}

ansi_scrollUp() {
  printf '%s%sS' "$ANSI_CSI" "${1-}"
}

ansi_icon() {
  printf '%s1;%s%s' "$ANSI_OSC" "${1-}" "$ANSI_ST"
}

ansi_title() {
  printf '%s2;%s%s' "$ANSI_OSC" "${1-}" "$ANSI_ST"
}

ansi_showCursor() {
  printf '%s?25h' "$ANSI_CSI"
}

ansi_showHelp() {
  cat <<EOF
Generate ANSI escape codes

Please keep in mind that your terminal must support the code in order for you
to see the effect properly.

Usage
    ansi [OPTIONS] [TEXT TO OUTPUT]

Option processing stops at the first unknown option or at "--".  Options
are applied in order as specified on the command line.  Unless --no-restore
is used, the options are unapplied in reverse order, restoring your
terminal to normal.

Optional parameters are surrounded in brackets and use reasonable defaults.
For instance, using --down will move the cursor down one line and --down=10
moves the cursor down 10 lines.

Display Manipulation
    --insert-chars[=N], --insert-char[=N], --ich[=N]
                             Insert blanks at cursor, shifting the line right.
    --erase-display[=N], --ed[=N]
                             Erase in display. 0=below, 1=above, 2=all,
                             3=saved.
    --erase-line=[N], --el[=N]
                             Erase in line. 0=right, 1=left, 2=all.
    --insert-lines[=N], --insert-line[=N], --il[=N]
    --delete-lines[=N], --delete-line[=N], --dl[=N]
    --delete-chars[=N], --delete-char[=N], --dch[=N]
    --scroll-up[=N], --su[=N]
    --scroll-down[=N], --sd[=N]
    --erase-chars[=N], --erase-char[=N], --ech[=N]
    --repeat[=N], --rep[=N]  Repeat preceding character N times.

Cursor:
    --up[=N], --cuu[=N]
    --down[=N], --cud[=N]
    --forward[=N], --cuf[=N]
    --backward[=N], --cub[=N]
    --next-line[=N], --cnl[=N]
    --previous-line[=N], --prev-line[=N], --cpl[=N]
    --column[=N], --cha[=N]
    --position[=[ROW],[COL]], --cup[=[ROW],[=COL]]
    --tab-forward[=N]        Move forward N tab stops.
    --tab-backward[=N]       Move backward N tab stops.
    --column-relative[=N], --hpr[=N]
    --line[=N], --vpa[=N]
    --line-relative[=N], --vpr[=N]
    --save-cursor            Saves the cursor position.  Restores the cursor
                             after writing text to the terminal unless
                             --no-restore is also used.
    --restore-cursor         Just restores the cursor.
    --hide-cursor            Will automatically show cursor unless --no-restore
                             is also used.
    --show-cursor

Text:
    Attributes:
        --bold, --faint, --normal
        --italic, --fraktur, --plain
        --underline, --double-underline, --no-underline
        --blink, --rapid-blink, --no-blink
        --inverse, --no-inverse
        --invisible, --visible
        --strike, --no-strike
        --frame, --encircle, --no-border
        --overline, --no-overline
        --ideogram-right, --ideogram-right-double, --ideogram-left,
        --ideogram-left-double, --ideogram-stress, --reset-ideogram
        --font=NUM (NUM must be from 0 through 9 and 0 is the primary font)
    Foreground:
        --black, --red, --green, --yellow, --blue, --magenta, --cyan, --white,
        --black-intense, --red-intense, --green-intense, --yellow-intense,
        --blue-intense, --magenta-intense, --cyan-intense, --white-intense,
        --color=CODE, --rgb=R,G,B
    Background:
        --bg-black, --bg-red, --bg-green, --bg-yellow, --bg-blue,
        --bg-magenta, --bg-cyan, --bg-white, --bg-black-intense,
        --bg-red-intense, --bg-green-intense, --bg-yellow-intense,
        --bg-blue-intense, --bg-magenta-intense, --bg-cyan-intense,
        --bg-white-intense, --bg-color=CODE, --bg-rgb=R,G,B
    Reset:
        --reset-attrib       Removes bold, italics, etc.
        --reset-foreground   Sets foreground to default color.
        --reset-background   Sets background to default color.
        --reset-color        Resets attributes, foreground, background.
        --reset-font         Switches back to the primary font.

Report:
    ** NOTE:  These require reading from stdin.  Results are sent to stdout.
    ** If no response from terminal in 1 second, these commands fail.
    --report-position        ROW,COL
    --report-window-state    "open" or "iconified"
    --report-window-position X,Y
    --report-window-pixels   HEIGHT,WIDTH
    --report-window-chars    ROWS,COLS
    --report-screen-chars    ROWS,COLS of the entire screen
    --report-icon
    --report-title

Miscellaneous:
    --color-table            Display a color table.
    --color-codes            Show the different color codes.
    --icon=NAME              Set the terminal's icon name.
    --title=TITLE            Set the terminal's window title.
    --no-restore             Do not issue reset codes when changing colors.
                             For example, if you change the color to green,
                             normally the color is restored to default
                             afterwards.  With this flag, the color will
                             stay green even when the command finishes.
    -n, --no-newline         Suppress newline at the end of the line.
    --bell                   Add the terminal's bell sequence to the output.
    --reset                  Reset colors, clear screen, show cursor, move
                             cursor to (1,1), and reset the font.
EOF
}

ansi_strike() {
  printf '%s9m' "$ANSI_CSI"
}

ansi_tabBackward() {
  printf '%s%sZ' "$ANSI_CSI" "${1-}"
}

ansi_tabForward() {
  printf '%s%sI' "$ANSI_CSI" "${1-}"
}

ansi_underline() {
  printf '%s4m' "$ANSI_CSI"
}

ansi_up() {
  printf '%s%sA' "$ANSI_CSI" "${1-}"
}

ansi_visible() {
  printf '%s28m' "$ANSI_CSI"
}

ansi_white() {
  printf '%s37m' "$ANSI_CSI"
}

ansi_whiteIntense() {
  printf '%s97m' "$ANSI_CSI"
}

ansi_yellow() {
  printf '%s33m' "$ANSI_CSI"
}

ansi_yellowIntense() {
  printf '%s93m' "$ANSI_CSI"
}

ansi() {
  local addNewline b g m r readOptions restoreText restoreCursorPosition restoreCursorVisibility supported triggerRestore
  local m10 m22 m23 m24 m25 m27 m28 m29 m39 m49 m54 m55 m65

  addNewline=true
  m10=
  m22=
  m23=
  m24=
  m25=
  m27=
  m28=
  m29=
  m39=
  m49=
  m54=
  m55=
  m65=
  readOptions=true
  restoreCursorPosition=false
  restoreCursorVisibility=false
  restoreText=false
  supported=true
  triggerRestore=true

  if ! ansi_isAnsiSupported; then
    supported=false
  fi

  while $readOptions && [[ $# -gt 0 ]]; do
    case "$1" in
    --help | -h | -\?)
      ansi_showHelp
      return 0
      ;;

    # Display Manipulation
    --insert-chars | --insert-char | --ich)
      $supported && ansi_insertChars
      ;;

    --insert-chars=* | insert-char=* | --ich=*)
      $supported && ansi_insertChars "${1#*=}"
      ;;

    --erase-display | --ed)
      $supported && ansi_eraseDisplay
      ;;

    --erase-display=* | --ed=*)
      $supported && ansi_eraseDisplay "${1#*=}"
      ;;

    --erase-line | --el)
      $supported && ansi_eraseLine
      ;;

    --erase-line=* | --el=*)
      $supported && ansi_eraseLine "${1#*=}"
      ;;

    --insert-lines | --insert-line | --il)
      $supported && ansi_insertLines
      ;;

    --insert-lines=* | --insert-line=* | --il=*)
      $supported && ansi_insertLines "${1#*=}"
      ;;

    --delete-lines | --delete-line | --dl)
      $supported && ansi_deleteLines
      ;;

    --delete-lines=* | --delete-line=* | --dl=*)
      $supported && ansi_deleteLines "${1#*=}"
      ;;

    --delete-chars | --delete-char | --dch)
      $supported && ansi_deleteChars
      ;;

    --delete-chars=* | --delete-char=* | --dch=*)
      $supported && ansi_deleteChars "${1#*=}"
      ;;

    --scroll-up | --su)
      $supported && ansi_scrollUp
      ;;

    --scroll-up=* | --su=*)
      $supported && ansi_scrollUp "${1#*=}"
      ;;

    --scroll-down | --sd)
      $supported && ansi_scrollDown
      ;;

    --scroll-down=* | --sd=*)
      $supported && ansi_scrollDown "${1#*=}"
      ;;

    --erase-chars | --erase-char | --ech)
      $supported && ansi_eraseChars
      ;;

    --erase-chars=* | --erase-char=* | --ech=*)
      $supported && ansi_eraseChars "${1#*=}"
      ;;

    --repeat | --rep)
      $supported && ansi_repeat
      ;;

    --repeat=* | --rep=N)
      $supported && ansi_repeat "${1#*=}"
      ;;

    # Cursor Positioning
    --up | --cuu)
      $supported && ansi_up
      ;;

    --up=* | --cuu=*)
      $supported && ansi_up "${1#*=}"
      ;;

    --down | --cud)
      $supported && ansi_down
      ;;

    --down=* | --cud=*)
      $supported && ansi_down "${1#*=}"
      ;;

    --forward | --cuf)
      $supported && ansi_forward
      ;;

    --forward=* | --cuf=*)
      $supported && ansi_forward "${1#*=}"
      ;;

    --backward | --cub)
      $supported && ansi_backward
      ;;

    --backward=* | --cub=*)
      $supported && ansi_backward "${1#*=}"
      ;;

    --next-line | --cnl)
      $supported && ansi_nextLine
      ;;

    --next-line=* | --cnl=*)
      $supported && ansi_nextLine "${1#*=}"
      ;;

    --previous-line | --prev-line | --cpl)
      $supported && ansi_previousLine
      ;;

    --previous-line=* | --prev-line=* | --cpl=*)
      $supported && ansi_previousLine "${1#*=}"
      ;;

    --column | --cha)
      $supported && ansi_column
      ;;

    --column=* | --cha=*)
      $supported && ansi_column "${1#*=}"
      ;;

    --position | --cup)
      $supported && ansi_position
      ;;

    --position=* | --cup=*)
      $supported && ansi_position "${1#*=}"
      ;;

    --tab-forward | --cht)
      $supported && ansi_tabForward
      ;;

    --tab-forward=* | --cht=*)
      $supported && ansi_tabForward "${1#*=}"
      ;;

    --tab-backward | --cbt)
      $supported && ansi_tabBackward
      ;;

    --tab-backward=* | --cbt=*)
      $supported && ansi_tabBackward "${1#*=}"
      ;;

    --column-relative | --hpr)
      $supported && ansi_columnRelative
      ;;

    --column-relative=* | --hpr=*)
      $supported && ansi_columnRelative "${1#*=}"
      ;;

    --line | --vpa)
      $supported && ansi_line
      ;;

    --line=* | --vpa=*)
      $supported && ansi_line "${1#*=}"
      ;;

    --line-relative | --vpr)
      $supported && ansi_lineRelative
      ;;

    --line-relative=* | --vpr=*)
      $supported && ansi_lineRelative "${1#*=}"
      ;;

    --save-cursor)
      $supported && ansi_saveCursor
      restoreCursorPosition=true
      ;;

    --restore-cursor)
      $supported && ansi_restoreCursor
      ;;

    --hide-cursor)
      $supported && ansi_hideCursor
      restoreCursorVisibility=true
      ;;

    --show-cursor)
      $supported && ansi_showCursor
      ;;

    # Colors - Attributes
    --bold)
      $supported && ansi_bold
      restoreText=true
      m22="22;"
      ;;

    --faint)
      $supported && ansi_faint
      restoreText=true
      m22="22;"
      ;;

    --italic)
      $supported && ansi_italic
      restoreText=true
      m23="23;"
      ;;

    --underline)
      $supported && ansi_underline
      restoreText=true
      m24="24;"
      ;;

    --blink)
      $supported && ansi_blink
      restoreText=true
      m25="25;"
      ;;

    --rapid-blink)
      $supported && ansi_rapidBlink
      restoreText=true
      m25="25;"
      ;;

    --inverse)
      $supported && ansi_inverse
      restoreText=true
      m27="27;"
      ;;

    --invisible)
      $supported && ansi_invisible
      restoreText=true
      m28="28;"
      ;;

    --strike)
      $supported && ansi_strike
      restoreText=true
      m29="29;"
      ;;

    --font | --font=0)
      $supported && ansi_resetFont
      ;;

    --font=[123456789])
      $supported && ansi_font "${1#*=}"
      restoreText=true
      m10="10;"
      ;;

    --fraktur)
      $supported && ansi_fraktur
      restoreText=true
      m23="23;"
      ;;

    --double-underline)
      $supported && ansi_doubleUnderline
      restoreText=true
      m24="24;"
      ;;

    --normal)
      $supported && ansi_normal
      ;;

    --plain)
      $supported && ansi_plain
      ;;

    --no-underline)
      $supported && ansi_noUnderline
      ;;

    --no-blink)
      $supported && ansi_noBlink
      ;;

    --no-inverse)
      $supported && ansi_noInverse
      ;;

    --visible)
      $supported && ansi_visible
      ;;

    --no-strike)
      $supported && ansi_noStrike
      ;;

    --frame)
      $supported && ansi_frame
      restoreText=true
      m54="54;"
      ;;

    --encircle)
      $supported && ansi_encircle
      restoreText=true
      m54="54;"
      ;;

    --overline)
      $supported && ansi_overline
      restoreText=true
      m55="55;"
      ;;

    --no-border)
      $supported && ansi_noBorder
      ;;

    --no-overline)
      $supported && ansi_noOverline
      ;;

    # Colors - Foreground
    --black)
      $supported && ansi_black
      restoreText=true
      m39="39;"
      ;;

    --red)
      $supported && ansi_red
      restoreText=true
      m39="39;"
      ;;

    --green)
      $supported && ansi_green
      restoreText=true
      m39="39;"
      ;;

    --yellow)
      $supported && ansi_yellow
      restoreText=true
      m39="39;"
      ;;

    --blue)
      $supported && ansi_blue
      restoreText=true
      m39="39;"
      ;;

    --magenta)
      $supported && ansi_magenta
      restoreText=true
      m39="39;"
      ;;

    --cyan)
      $supported && ansi_cyan
      restoreText=true
      m39="39;"
      ;;

    --white)
      $supported && ansi_white
      restoreText=true
      m39="39;"
      ;;

    --black-intense)
      $supported && ansi_blackIntense
      restoreText=true
      m39="39;"
      ;;

    --red-intense)
      $supported && ansi_redIntense
      restoreText=true
      m39="39;"
      ;;

    --green-intense)
      $supported && ansi_greenIntense
      restoreText=true
      m39="39;"
      ;;

    --yellow-intense)
      $supported && ansi_yellowIntense
      restoreText=true
      m39="39;"
      ;;

    --blue-intense)
      $supported && ansi_blueIntense
      restoreText=true
      m39="39;"
      ;;

    --magenta-intense)
      $supported && ansi_magentaIntense
      restoreText=true
      m39="39;"
      ;;

    --cyan-intense)
      $supported && ansi_cyanIntense
      restoreText=true
      m39="39;"
      ;;

    --white-intense)
      $supported && ansi_whiteIntense
      restoreText=true
      m39="39;"
      ;;

    --rgb=*,*,*)
      r=${1#*=}
      b=${r##*,}
      g=${r#*,}
      g=${g%,*}
      r=${r%%,*}
      $supported && ansi_rgb "$r" "$g" "$b"
      restoreText=true
      m39="39;"
      ;;

    --color=*)
      $supported && ansi_color "${1#*=}"
      restoreText=true
      m39="39;"
      ;;

    # Colors - Background
    --bg-black)
      $supported && ansi_bgBlack
      restoreText=true
      m49="49;"
      ;;

    --bg-red)
      $supported && ansi_bgRed
      restoreText=true
      m49="49;"
      ;;

    --bg-green)
      $supported && ansi_bgGreen
      restoreText=true
      m49="49;"
      ;;

    --bg-yellow)
      $supported && ansi_bgYellow
      restoreText=true
      m49="49;"
      ;;

    --bg-blue)
      $supported && ansi_bgBlue
      restoreText=true
      m49="49;"
      ;;

    --bg-magenta)
      $supported && ansi_bgMagenta
      restoreText=true
      m49="49;"
      ;;

    --bg-cyan)
      $supported && ansi_bgCyan
      restoreText=true
      m49="49;"
      ;;

    --bg-white)
      $supported && ansi_bgWhite
      restoreText=true
      m49="49;"
      ;;

    --bg-black-intense)
      $supported && ansi_bgBlackIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-red-intense)
      $supported && ansi_bgRedIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-green-intense)
      $supported && ansi_bgGreenIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-yellow-intense)
      $supported && ansi_bgYellowIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-blue-intense)
      $supported && ansi_bgBlueIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-magenta-intense)
      $supported && ansi_bgMagentaIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-cyan-intense)
      $supported && ansi_bgCyanIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-white-intense)
      $supported && ansi_bgWhiteIntense
      restoreText=true
      m49="49;"
      ;;

    --bg-rgb=*,*,*)
      r=${1#*=}
      b=${r##*,}
      g=${r#*,}
      g=${g%,*}
      r=${r%%,*}
      $supported && ansi_bgRgb "$r" "$g" "$b"
      restoreText=true
      m49="49;"
      ;;

    --bg-color=*)
      $supported && ansi_bgColor "${1#*=}"
      restoreText=true
      m49="49;"
      ;;

    # Colors - Reset
    --reset-attrib)
      $supported && ansi_resetAttributes
      ;;

    --reset-foreground)
      $supported && ansi_resetForeground
      ;;

    --reset-background)
      $supported && ansi_resetBackground
      ;;

    --reset-color)
      $supported && ansi_resetColor
      ;;

    --reset-font)
      $supported && ansi_resetFont
      ;;

    # Reporting
    --report-position)
      $supported || return 1
      ansi_reportPosition || return $?
      ;;

    --report-window-state)
      $supported || return 1
      ansi_reportWindowState || return $?
      ;;

    --report-window-position)
      $supported || return 1
      ansi_reportWindowPosition || return $?
      ;;

    --report-window-pixels)
      $supported || return 1
      ansi_reportWindowPixels || return $?
      ;;

    --report-window-chars)
      $supported || return 1
      ansi_reportWindowChars || return $?
      ;;

    --report-screen-chars)
      $supported || return 1
      ansi_reportScreenChars || return $?
      ;;

    --report-icon)
      $supported || return 1
      ansi_reportIcon || return $?
      ;;

    --report-title)
      $supported || return 1
      ansi_reportTitle || return $?
      ;;

    --ideogram-right)
      $supported && ansi_ideogramRight
      restoreText=true
      m65="65;"
      ;;

    --ideogram-right-double)
      $supported && ansi_ideogramRightDouble
      restoreText=true
      m65="65;"
      ;;

    --ideogram-left)
      $supported && ansi_ideogramLeft
      restoreText=true
      m65="65;"
      ;;

    --ideogram-left-double)
      $supported && ansi_ideogramLeftDouble
      restoreText=true
      m65="65;"
      ;;

    --ideogram-stress)
      $supported && ansi_ideogramStress
      restoreText=true
      m65="65;"
      ;;

    --reset-ideogram)
      $supported && ansi_noIdeogram
      ;;

    # Miscellaneous
    --color-codes)
      if ! $supported; then
        echo "ANSI is not supported in this terminal."
      else
        ansi_colorCodes
      fi

      return 0
      ;;

    --color-table)
      if ! $supported; then
        echo "ANSI is not supported in this terminal."
      else
        ansi_colorTable
      fi

      return 0
      ;;

    --icon)
      $supported && ansi_icon ""
      ;;

    --icon=*)
      $supported && ansi_icon "${1#*=}"
      ;;

    --title)
      $supported && ansi_title ""
      ;;

    --title=*)
      $supported && ansi_title "${1#*=}"
      ;;

    --no-restore)
      triggerRestore=false
      ;;

    -n | --no-newline)
      addNewline=false
      ;;

    --bell)
      ansi_bell
      ;;

    --reset)
      $supported || return 0
      ansi_reset
      ;;

    --)
      readOptions=false
      shift
      ;;

    *)
      readOptions=false
      ;;
    esac

    if $readOptions; then
      shift
    fi
  done

  printf '%s' "${1-}"

  if [[ "$#" -gt 1 ]]; then
    shift || :
    printf "${IFS:0:1}%s" "${@}"
  fi

  if $supported && $triggerRestore; then
    if $restoreCursorPosition; then
      ansi_restoreCursor
    fi

    if $restoreCursorVisibility; then
      ansi_showCursor
    fi

    if $restoreText; then
      m="$m10$m22$m23$m24$m25$m27$m28$m29$m39$m49$m54$m55$m65"
      printf '%s%sm' "$ANSI_CSI" "${m%;}"
    fi
  fi

  if $addNewline; then
    printf '\n'
  fi
}

# Run if not sourced
if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
  ansi "$@" || exit $?
fi

#>= Additions
#-----------------------------------------------------------------------------
function ansir() {
  ansi_resetAttributes
  ansi_resetColor
}
