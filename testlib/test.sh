#!/usr/bin/env bash
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <grimeton@gmx.net> wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return, Grimeton.
#
# The license text was written by <phk@FreeBSD.ORG> - Poul-Henning Kamp
# ----------------------------------------------------------------------------
# I was thinking about using Markdown inside the bash script for documentation,
# but it didn't work. So back to the good ole comments.
#

declare -r __T_PWD="$(dirname "$(realpath "${0}")")"

if [[ ! -f "${__T_PWD}/__test.sh" ]]; then
    echo "Cannot find '__test.sh'. Exiting." >&2
    exit 254;
fi

if [[ ! -x "${__T_PWD}/__test.sh" ]]; then
    echo "'${__T_PWD}/__test.sh' is missing the executable bit. Exiting." >&2
    exit 253;
fi

exec /usr/bin/env -i "${__T_PWD}/__test.sh"

