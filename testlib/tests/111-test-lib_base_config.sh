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
#
if ! (return 0 2>/dev/null); then
    echo "THIS IS A LIBRARY FILE AND SHOULD NOT BE CALLED DIRECTLY. '($(realpath "${0}"))'"
    exit 254
fi

#####
#
# - BEGIN: lib_base_config.sh
#

__tlogls lib_base_config
#####
#
# - __config_distribution_find
#
__tlogfs __config_distribution_find

unset __T_UNSET
declare -a __T_UNSET=(__X_DISTRIBUTIONS_EXPECTED __X_ERROR __X_RET_ARRAY __X_TEST_VALUES __X_TEST_VALUES_STRING)
for __X_VNAME in "${__X_UNSET[@]}"; do
    if [[ -R "${__X_VNAME}" ]]; then
        unset "${__X_VNAME}"
        unset -n "${__X_VNAME}"
    else
        unset "${__X_VNAME}"
    fi
done

declare -i __X_DISTRIBUTIONS_EXPECTED=1
declare -i __X_ERROR=0
declare -a __X_RET_ARRAY=()
declare -A __X_TEST_VALUES=(
    [ID]="ubuntu"
    [NAME]="Ubuntu"
    [VERSION_ID]="16.04"
    [VERSION_CODENAME]="xenial"
    [COMPRESSION]="gz"
    [COMMENT]=""
)
declare __X_TEST_VALUES_STRING=""

for __X_KEY in "${!__X_TEST_VALUES[@]}"; do
    __X_TEST_VALUES_STRING+="[${__X_KEY}]=\"${__X_TEST_VALUES[${__X_KEY}]}\" "
done

__tlogts "Testing with distribution info: '${__X_TEST_VALUES_STRING}'...\n"

unset __X_TEST_VALUES_STRING

if __config_distribution_find \
    "${__X_TEST_VALUES[ID]}" \
    "${__X_TEST_VALUES[NAME]}" \
    "${__X_TEST_VALUES[VERSION_ID]}" \
    "${__X_TEST_VALUES[VERSION_CODENAME]}" \
    "${__X_TEST_VALUES[COMPRESSION]}" \
    "${__X_TEST_VALUES[COMMENT]}" \
    __X_RET_ARRAY; then

    for __X_DINFO in "${__X_RET_ARRAY[@]}"; do
        if __aarray_exists "${__X_DINFO}"; then
            declare -n __X_RA="${__X_DINFO}"
        else
            continue
        fi

        for __X_NAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
            if [[ -z ${__X_RA[${__X_NAME}]+x} ]]; then
                __tlog " -- Field '${__X_NAME}' does not exist in '__T_RA' of '${__X_DINFO}'... "
                __tloge " FAIL."
                __T_ERROR=1
                continue
            fi
            if [[ ${__X_TEST_VALUES[${__X_NAME}]+x} ]]; then
                if [[ "${__X_RA[${__X_NAME}]}x" == "${__X_TEST_VALUES[${__X_NAME}]}x" ]]; then
                    __tlog " -- Field '${__X_NAME}' exists and matches... "
                    __tlogp " PASS."
                else
                    __tlog " -- Field '${__X_NAME}' exists but does not match... "
                    __tloge " FAIL."
                fi
            else
                __tlog " -- Field '${__X_NAME}' was empty when requested, not comparing."
                __tlogp " PASS."
            fi
        done
    done
else
    declare -i __X_ERROR=$?
    if [[ ${__X_DISTRIBUTIONS_EXPECTED} -eq 0 ]]; then
        if [[ ${__X_ERROR} -eq 1 ]]; then
            __X_ERROR=0
        fi
    fi
fi

__tlog " -- Overall: "
if [[ ${__X_ERROR} == 0 ]]; then
    __tlogtp ${__X_ERROR}
else
    __tlogte ${__X_ERROR}
fi

unset __T_UNSET
declare -a __T_UNSET=(__X_DISTRIBUTIONS_EXPECTED __X_ERROR __X_RET_ARRAY __X_TEST_VALUES __X_TEST_VALUES_STRING)
for __X_VNAME in "${__X_UNSET[@]}"; do
    if [[ -R "${__X_VNAME}" ]]; then
        unset "${__X_VNAME}"
        unset -n "${__X_VNAME}"
    else
        unset "${__X_VNAME}"
    fi
done

declare -i __X_DISTRIBUTIONS_EXPECTED=0
declare -i __X_ERROR=0
declare -a __X_RET_ARRAY=()
declare -A __X_TEST_VALUES=(
    [ID]="blububuntu"
    [NAME]="Ubuntu"
    [VERSION_ID]="16.04"
    [VERSION_CODENAME]="xenial"
    [COMPRESSION]="gz"
    [COMMENT]=""
)
declare __X_TEST_VALUES_STRING=""

for __X_KEY in "${!__X_TEST_VALUES[@]}"; do
    __X_TEST_VALUES_STRING+="[${__X_KEY}]=\"${__X_TEST_VALUES[${__X_KEY}]}\" "
done

__tlogts "Testing with distribution info: '${__X_TEST_VALUES_STRING}'..."

unset __X_TEST_VALUES_STRING

if __config_distribution_find \
    "${__X_TEST_VALUES[ID]}" \
    "${__X_TEST_VALUES[NAME]}" \
    "${__X_TEST_VALUES[VERSION_ID]}" \
    "${__X_TEST_VALUES[VERSION_CODENAME]}" \
    "${__X_TEST_VALUES[COMPRESSION]}" \
    "${__X_TEST_VALUES[COMMENT]}" \
    __X_RET_ARRAY; then

    for __X_DINFO in "${__X_RET_ARRAY[@]}"; do
        if __aarray_exists "${__X_DINFO}"; then
            declare -n __X_RA="${__X_DINFO}"
        else
            continue
        fi

        for __X_NAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
            if [[ -z ${__X_RA[${__X_NAME}]+x} ]]; then
                __tlog " -- Field '${__X_NAME}' does not exist in '__X_RA' of '${__X_DINFO}'... "
                __tloge " FAIL."
                __T_ERROR=1
                continue
            fi
            if [[ ${__X_TEST_VALUES[${__X_NAME}]+x} ]] && [[ "${__X_TEST_VALUES[${__X_NAME}]}x" != "x" ]]; then
                if [[ "${__X_RA[${__X_NAME}]}x" == "${__X_TEST_VALUES[${__X_NAME}]}x" ]]; then
                    __tlog " -- Field '${__X_NAME}' exists and matches... "
                    __tlogp " PASS."
                else
                    __tlog " -- Field '${__X_NAME}' exists but does not match... "
                    __tloge " FAIL."
                fi
            else
                __tlog " -- Field '${__X_NAME}' was empty when requested, not comparing."
                __tlogp " PASS."
            fi
        done
    done
else
    declare -i __X_ERROR=$?
    if [[ ${__X_DISTRIBUTIONS_EXPECTED} -eq 0 ]]; then
        if [[ ${__X_ERROR} -eq 1 ]]; then
            __X_ERROR=0
        fi
    fi
fi

if [[ ${__X_ERROR} == 0 ]]; then
    __tlogtp
else
    __tlogte
fi
#####
#
# - __config_distribution_verify
#
__tlogfs __config_distribution_verify

unset __T_UNSET
declare -a __T_UNSET=(__X_DISTRIBUTIONS_EXPECTED __X_ERROR __X_RET_ARRAY __X_TEST_VALUES __X_TEST_VALUES_STRING)
for __X_VNAME in "${__X_UNSET[@]}"; do
    if [[ -R "${__X_VNAME}" ]]; then
        unset "${__X_VNAME}"
        unset -n "${__X_VNAME}"
    else
        unset "${__X_VNAME}"
    fi
done

declare -i __X_DISTRIBUTIONS_EXPECTED=1
declare -i __X_ERROR=0
declare -a __X_RET_ARRAY=()
declare -A __X_TEST_VALUES=()

for __X_VNAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
    if [[ "${!__X_VNAME+x}x" == "x" ]]; then
        __X_TEST_VALUES[${__X_VNAME}]=""
    else
        __X_TEST_VALUES[${__X_VNAME}]="${!__X_VNAME}"
    fi
done

declare __X_TEST_VALUES_STRING=""

for __X_KEY in "${!__X_TEST_VALUES[@]}"; do
    __X_TEST_VALUES_STRING+="[${__X_KEY}]=\"${__X_TEST_VALUES[${__X_KEY}]}\" "
done

__tlogts "Testing with distribution info: '${__X_TEST_VALUES_STRING}'...\n"

unset __X_TEST_VALUES_STRING

if __config_distribution_verify \
    "${__X_TEST_VALUES[ID]}" \
    "${__X_TEST_VALUES[NAME]}" \
    "${__X_TEST_VALUES[VERSION_ID]}" \
    "${__X_TEST_VALUES[VERSION_CODENAME]}" \
    "${__X_TEST_VALUES[COMPRESSION]}" \
    "${__X_TEST_VALUES[COMMENT]}" \
    __X_RET_ARRAY; then

    for __X_DINFO in "${__X_RET_ARRAY[@]}"; do
        if __aarray_exists "${__X_DINFO}"; then
            declare -n __X_RA="${__X_DINFO}"
        else
            continue
        fi

        for __X_NAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
            if [[ -z ${__X_RA[${__X_NAME}]+x} ]]; then
                __tlog " -- Field '${__X_NAME}' does not exist in '__T_RA' of '${__X_DINFO}'... "
                __tloge " FAIL."
                __T_ERROR=1
                continue
            fi
            if [[ ${__X_TEST_VALUES[${__X_NAME}]+x} ]] && [[ "${__X_TEST_VALUES[${__X_NAME}]}x" != "x" ]]; then
                if [[ "${__X_RA[${__X_NAME}]}x" == "${__X_TEST_VALUES[${__X_NAME}]}x" ]]; then
                    __tlog " -- Field '${__X_NAME}' exists and matches... "
                    __tlogp " PASS."
                else
                    __tlog " -- Field '${__X_NAME}' exists but does not match... "
                    __tloge " FAIL."
                fi
            else
                __tlog " -- Field '${__X_NAME}' was empty when requested, not comparing."
                __tlogp " PASS."
            fi
        done
    done
else
    declare -i __X_ERROR=$?
    if [[ ${__X_DISTRIBUTIONS_EXPECTED} -eq 0 ]]; then
        if [[ ${__X_ERROR} -eq 1 ]]; then
            __X_ERROR=0
        fi
    fi
fi

if [[ ${__X_ERROR} == 0 ]]; then
    __tlogtp
else
    __tlogte
fi

unset __T_UNSET
declare -a __T_UNSET=(__X_DISTRIBUTIONS_EXPECTED __X_ERROR __X_RET_ARRAY __X_TEST_VALUES __X_TEST_VALUES_STRING)
for __X_VNAME in "${__X_UNSET[@]}"; do
    if [[ -R "${__X_VNAME}" ]]; then
        unset "${__X_VNAME}"
        unset -n "${__X_VNAME}"
    else
        unset "${__X_VNAME}"
    fi
done

declare -i __X_DISTRIBUTIONS_EXPECTED=0
declare -i __X_ERROR=0
declare -a __X_RET_ARRAY=()
declare -A __X_TEST_VALUES=()

for __X_VNAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
    if [[ "${!__X_VNAME+x}x" == "x" ]]; then
        __X_TEST_VALUES[${__X_VNAME}]=""
    else
        __X_TEST_VALUES[${__X_VNAME}]="${!__X_VNAME}"
    fi
done
__X_TEST_VALUES[NAME]="BLUBB"
declare __X_TEST_VALUES_STRING=""

for __X_KEY in "${!__X_TEST_VALUES[@]}"; do
    __X_TEST_VALUES_STRING+="[${__X_KEY}]=\"${__X_TEST_VALUES[${__X_KEY}]}\" "
done

__tlogts "Testing with distribution info: '${__X_TEST_VALUES_STRING}'...\n"

unset __X_TEST_VALUES_STRING

if __config_distribution_verify \
    "${__X_TEST_VALUES[ID]}" \
    "${__X_TEST_VALUES[NAME]}" \
    "${__X_TEST_VALUES[VERSION_ID]}" \
    "${__X_TEST_VALUES[VERSION_CODENAME]}" \
    "${__X_TEST_VALUES[COMPRESSION]}" \
    "${__X_TEST_VALUES[COMMENT]}" \
    __X_RET_ARRAY; then

    for __X_DINFO in "${__X_RET_ARRAY[@]}"; do
        if __aarray_exists "${__X_DINFO}"; then
            declare -n __X_RA="${__X_DINFO}"
        else
            continue
        fi

        for __X_NAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
            if [[ -z ${__X_RA[${__X_NAME}]+x} ]]; then
                __tlog " -- Field '${__X_NAME}' does not exist in '__T_RA' of '${__X_DINFO}'... "
                __tloge " FAIL."
                __T_ERROR=1
                continue
            fi
            if [[ ${__X_TEST_VALUES[${__X_NAME}]+x} ]] && [[ "${__X_TEST_VALUES[${__X_NAME}]}x" != "x" ]]; then
                if [[ "${__X_RA[${__X_NAME}]}x" == "${__X_TEST_VALUES[${__X_NAME}]}x" ]]; then
                    __tlog " -- Field '${__X_NAME}' exists and matches... "
                    __tlogp " PASS."
                else
                    __tlog " -- Field '${__X_NAME}' exists but does not match... "
                    __tloge " FAIL."
                fi
            else
                __tlog " -- Field '${__X_NAME}' was empty when requested, not comparing."
                __tlogp " PASS."
            fi
        done
    done
else
    declare -i __X_ERROR=$?
    if [[ ${__X_DISTRIBUTIONS_EXPECTED} -eq 0 ]]; then
        if [[ ${__X_ERROR} -eq 1 ]]; then
            __X_ERROR=0
        fi
    fi
fi

if [[ ${__X_ERROR} == 0 ]]; then
    __tlogtp
else
    __tlogte
fi
#####
#
# - __config_distribution_get
#
__tlogfs __config_distribution_get

unset __T_UNSET
declare -a __T_UNSET=(__X_DISTRIBUTIONS_EXPECTED __X_ERROR __X_RET_ARRAY __X_TEST_VALUES __X_TEST_VALUES_STRING)
for __X_VNAME in "${__X_UNSET[@]}"; do
    if [[ -R "${__X_VNAME}" ]]; then
        unset "${__X_VNAME}"
        unset -n "${__X_VNAME}"
    else
        unset "${__X_VNAME}"
    fi
done

declare -i __X_DISTRIBUTIONS_EXPECTED=1
declare -i __X_ERROR=0
declare -a __X_RET_ARRAY=()
declare -A __X_TEST_VALUES=()

for __X_VNAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
    if [[ "${!__X_VNAME+x}x" == "x" ]]; then
        __X_TEST_VALUES[${__X_VNAME}]=""
    else
        __X_TEST_VALUES[${__X_VNAME}]="${!__X_VNAME}"
    fi
done

declare __X_TEST_VALUES_STRING=""

for __X_KEY in "${!__X_TEST_VALUES[@]}"; do
    __X_TEST_VALUES_STRING+="[${__X_KEY}]=\"${__X_TEST_VALUES[${__X_KEY}]}\" "
done

__tlogts "Testing with distribution info: '${__X_TEST_VALUES_STRING}'..."

unset __X_TEST_VALUES_STRING

if __config_distribution_get \
    "${__X_TEST_VALUES[ID]}" \
    "${__X_TEST_VALUES[NAME]}" \
    "${__X_TEST_VALUES[VERSION_ID]}" \
    "${__X_TEST_VALUES[VERSION_CODENAME]}" \
    "${__X_TEST_VALUES[COMPRESSION]}" \
    "${__X_TEST_VALUES[COMMENT]}" \
    __X_RET_ARRAY; then

    for __X_DINFO in "${__X_RET_ARRAY[@]}"; do
        if __aarray_exists "${__X_DINFO}"; then
            declare -n __X_RA="${__X_DINFO}"
        else
            continue
        fi

        for __X_NAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
            if [[ -z ${__X_RA[${__X_NAME}]+x} ]]; then
                __tlog " -- Field '${__X_NAME}' does not exist in '__T_RA' of '${__X_DINFO}'... "
                __tloge " FAIL."
                __T_ERROR=1
                continue
            fi
            if [[ ${__X_TEST_VALUES[${__X_NAME}]+x} ]] && [[ "${__X_TEST_VALUES[${__X_NAME}]}x" != "x" ]]; then
                if [[ "${__X_RA[${__X_NAME}]}x" == "${__X_TEST_VALUES[${__X_NAME}]}x" ]]; then
                    __tlog " -- Field '${__X_NAME}' exists and matches... "
                    __tlogp " PASS."
                else
                    __tlog " -- Field '${__X_NAME}' exists but does not match... "
                    __tloge " FAIL."
                fi
            else
                __tlog " -- Field '${__X_NAME}' was empty when requested, not comparing."
                __tlogp " PASS."
            fi
        done
    done
else
    declare -i __X_ERROR=$?
    if [[ ${__X_DISTRIBUTIONS_EXPECTED} -eq 0 ]]; then
        if [[ ${__X_ERROR} -eq 1 ]]; then
            __X_ERROR=0
        fi
    fi
fi

if [[ ${__X_ERROR} == 0 ]]; then
    __tlogtp
else
    __tlogte
fi

unset __T_UNSET
declare -a __T_UNSET=(__X_DISTRIBUTIONS_EXPECTED __X_ERROR __X_RET_ARRAY __X_TEST_VALUES __X_TEST_VALUES_STRING)
for __X_VNAME in "${__X_UNSET[@]}"; do
    if [[ -R "${__X_VNAME}" ]]; then
        unset "${__X_VNAME}"
        unset -n "${__X_VNAME}"
    else
        unset "${__X_VNAME}"
    fi
done

declare -i __X_DISTRIBUTIONS_EXPECTED=0
declare -i __X_ERROR=0
declare -a __X_RET_ARRAY=()
declare -A __X_TEST_VALUES=()

for __X_VNAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
    if [[ "${!__X_VNAME+x}x" == "x" ]]; then
        __X_TEST_VALUES[${__X_VNAME}]=""
    else
        __X_TEST_VALUES[${__X_VNAME}]="${!__X_VNAME}"
    fi
done
__X_TEST_VALUES[NAME]="BLUBB"
declare __X_TEST_VALUES_STRING=""

for __X_KEY in "${!__X_TEST_VALUES[@]}"; do
    __X_TEST_VALUES_STRING+="[${__X_KEY}]=\"${__X_TEST_VALUES[${__X_KEY}]}\" "
done

__tlogts "Testing with distribution info: '${__X_TEST_VALUES_STRING}'..."

unset __X_TEST_VALUES_STRING

if __config_distribution_get \
    "${__X_TEST_VALUES[ID]}" \
    "${__X_TEST_VALUES[NAME]}" \
    "${__X_TEST_VALUES[VERSION_ID]}" \
    "${__X_TEST_VALUES[VERSION_CODENAME]}" \
    "${__X_TEST_VALUES[COMPRESSION]}" \
    "${__X_TEST_VALUES[COMMENT]}" \
    __X_RET_ARRAY; then

    for __X_DINFO in "${__X_RET_ARRAY[@]}"; do
        if __aarray_exists "${__X_DINFO}"; then
            declare -n __X_RA="${__X_DINFO}"
        else
            continue
        fi

        for __X_NAME in ID NAME VERSION_ID VERSION_CODENAME COMPRESSION COMMENT; do
            if [[ -z ${__X_RA[${__X_NAME}]+x} ]]; then
                __tlog " -- Field '${__X_NAME}' does not exist in '__T_RA' of '${__X_DINFO}'... "
                __tloge " FAIL."
                __T_ERROR=1
                continue
            fi
            if [[ ${__X_TEST_VALUES[${__X_NAME}]+x} ]] && [[ "${__X_TEST_VALUES[${__X_NAME}]}x" != "x" ]]; then
                if [[ "${__X_RA[${__X_NAME}]}x" == "${__X_TEST_VALUES[${__X_NAME}]}x" ]]; then
                    __tlog " -- Field '${__X_NAME}' exists and matches... "
                    __tlogp " PASS."
                else
                    __tlog " -- Field '${__X_NAME}' exists but does not match... "
                    __tloge " FAIL."
                fi
            else
                __tlog " -- Field '${__X_NAME}' was empty when requested, not comparing."
                __tlogp " PASS."
            fi
        done
    done
else
    declare -i __X_ERROR=$?
    if [[ ${__X_DISTRIBUTIONS_EXPECTED} -eq 0 ]]; then
        if [[ ${__X_ERROR} -eq 1 ]]; then
            __X_ERROR=0
        fi
    fi
fi

if [[ ${__X_ERROR} == 0 ]]; then
    __tlogtp
else
    __tlogte
fi
