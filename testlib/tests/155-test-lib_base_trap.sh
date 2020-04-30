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
# unset -f __log_write
# function __log_write() { return 0; }

#####
#
# - lib_base_trap.sh
#
__tlogls lib_base_trap

#####
#
# - __trap_signal_exists
#
__tlogfs __trap_signal_exists
__tlogts "Error 99"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_exists; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} == 99 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 1 (characters)"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_exists SIGINVALID; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} == 1 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 1 (numbers)"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_exists 666; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 1 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Valid 'SIGWINCH'."
if __trap_signal_exists SIGWINCH; then
    __tlogtp $?
else
    __tlogte $?
fi

__tlogts "Valid '28'."
if __trap_signal_exists 28; then
    __tlogtp $?
else
    __tlogte $?
fi

#####
#
# - __trap_signal_name
#

__tlogfs __trap_signal_name
__tlogts "Error 2"
unset __T_ERROR
unset -n __T_ERROR
declare -- __T_R_VALUE=""
if __trap_signal_name; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 2 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 3"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_name SIGINVALID; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 3 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 4"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_name 666; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 4 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Valid, stdout 'SIGWINCH'."
unset __T_ERROR __T_RET
unset -n __T_ERROR __T_RET
declare __T_RET=""
if __T_RET="$(__trap_signal_name SIGWINCH)"; then
    declare -i __T_ERROR=$?
    if [[ "${__T_RET}" == "SIGWINCH" ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
else
    declare -i __T_ERROR=$?
    __tlogte ${__T_ERROR}
fi

__tlogts "Valid, stdout, '28'."

unset __T_ERROR __T_RET
unset -n __T_ERROR __T_RET
declare __T_RET=""

if __T_RET="$(__trap_signal_name 28)"; then
    declare -i __T_ERROR=$?
    if [[ "${__T_RET}" == "SIGWINCH" ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
else
    __tlogte $?
fi

__tlogts "Valid, out parameter, 'SIGWINCH'."
unset __T_ERROR __T_RET
unset -n __T_ERROR __T_RET
declare __T_RET=""
if __trap_signal_name SIGWINCH __T_RET; then
    declare -i __T_ERROR=$?
    if [[ "${__T_RET}" == "SIGWINCH" ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte "ERROR: __T_RET: '${__T_RET}' (${__T_ERROR})"
    fi
else
    __tlogte $?
fi

__tlogts "Valid, out parameters, '28'."
unset __T_ERROR __T_RET
unset -n __T_ERROR __T_RET
declare -- __T_RET=""
if __trap_signal_name 28 __T_RET; then
    declare -i __T_ERROR=$?
    if [[ "${__T_RET}" == "SIGWINCH" ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte "ERROR: __T_RET: '${__T_RET}' (${__T_ERROR})"
    fi
else
    __tlogte $?
fi

__tlogts "Valid, invalid out parameter, 'SIGWINCH'."
unset __T_DOES_NOT_EXIST __T_ERROR __T_RET
unset -n __T_DOES_NOT_EXIST __T_ERROR __T_RET
declare __T_RET=""
if __T_RET="$(__trap_signal_name SIGWINCH __DOES_NOT_EXIST)"; then
    declare -i __T_ERROR=$?
    if [[ "${__T_RET}" == "SIGWINCH" ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte "ERROR: __T_RET: '${__T_RET}' (${__T_ERROR})."
    fi
else
    __tlogte $?
fi

__tlogfs __trap_signal_arrayname_get
__tlogts "Error 2"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_arrayname_get; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 2 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 3"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_arrayname_get SIGINVALID; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} = 3 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Valid signal, stdout 'SIGWINCH'."
unset __T_ERROR __T_RET
unset -n __T_ERROR __T_RET
if __T_RET="$(__trap_signal_arrayname_get SIGWINCH)"; then
    declare -i __T_ERROR=$?
    if [[ "${__T_RET}" == "__TRAP_SIGNAL_ARRAY_SIGWINCH" ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte " ERROR: __T_RET: '${__T_RET}' (${__T_ERROR})."
    fi
else
    __tlogte $?
fi

__tlogts "Valid signal, stdout '28'."
unset __T_ERROR __T_RET
unset -n __T_ERROR __T_RET
if __T_RET="$(__trap_signal_arrayname_get 28)"; then
    declare -i __T_ERROR=$?
    if [[ "${__T_RET}" == "__TRAP_SIGNAL_ARRAY_SIGWINCH" ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
else
    __tlogtp $?
fi

__tlogts "Valid signal, out parameter, '28'."
unset __T_ERROR __T_RET __T_RET_FILE __T_RET_OUT
unset -n __T_ERROR __T_RET __T_RET_FILE __T_RET_OUT
declare __T_RET_FILE=""
__tlog_mktemp __T_RET_FILE
declare -a __T_RET=()
declare __T_RET_OUT=""
if __trap_signal_arrayname_get 28 __T_RET_OUT >"${__T_RET_FILE}" 2>&1; then
    declare -i __T_ERROR=$?
    if mapfile __T_RET <"${__T_RET_FILE}"; then
        if [[ "${__T_RET_OUT}" == "__TRAP_SIGNAL_ARRAY_SIGWINCH" ]] && [[ ${#__T_RET[@]} -lt 1 ]]; then
            __tlogtp "PASS: (${__T_ERROR})."
        else
            __tlogte "ERROR: __T_ERROR: '${__T_ERROR}' __T_RET: '${__T_RET[@]}' __T_RET_OUT: '${__T_RET_OUT}'"
        fi
    else
        __tlogte "ERROR: Could not read '${__T_RET_FILE}'."
    fi
else
    __tlogte $?
fi

#####
#
# - __trap_signal_array_create
#
__tlogfs __trap_signal_array_create
__tlogts "Error 2"
unset __T_ERROR __T_RET __T_RET_FILE __T_RET_OUT
unset -n __T_ERROR __T_RET __T_RET_FILE __T_RET_OUT
if __trap_signal_array_create; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 2 ]]; then
        __tlogtp "${__T_ERROR}"
    else
        __tlogte "${__T_ERROR}"
    fi
fi

unset __T_ERROR
unset -n __T_ERROR
__tlogts "Error 3 (Digits)"
if __trap_signal_array_create 666; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 3 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 3 (Name)"
if __trap_signal_array_create SIGINVALID; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 3 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Valid signal, checking for arrayname.."
unset __T_ERROR __T_RET __T_RET_FILE __T_RET_OUT __T_ARRAYNAME __TE_ARRAYNAME __TE_SIGNALNAME
unset -n __T_ERROR __T_RET __T_RET_FILE __T_RET_OUT __T_ARRAYNAME __TE_ARRAYNAME __TE_SIGNALNAME
declare __T_ARRAYNAME=""
declare __T_RET_FILE=""
__tlog_mktemp __T_RET_FILE
declare __TE_ARRAYNAME=""
declare __TE_REGEX_ARRAY='^declare -[^\ ]*a[^\ ]*\ .*$'
declare __TE_SIGNALNAME="SIGWINCH"
shopt -u nocasematch
if __trap_signal_arrayname_get "${__TE_SIGNALNAME}" __TE_ARRAYNAME; then
    if __trap_signal_array_create "${__TE_SIGNALNAME}" __T_ARRAYNAME >"${__T_RET_FILE}" 2>&1; then
        declare -i __T_ERROR=$?
        if [[ "${__T_ARRAYNAME}" == "${__TE_ARRAYNAME}" ]]; then
            if __T_RET="$(declare -p "${__T_ARRAYNAME}")"; then
                if [[ "${__T_RET}" =~ ${__TE_REGEX_ARRAY} ]]; then
                    if __tlog_file_empty "${__T_RET_FILE}"; then
                        __tlogtp ${__T_ERROR}
                    else
                        __tlogte " ERROR: __T_RET_FILE is not empty (${__T_ERROR}) ($?)."
                    fi
                else
                    __tlogte " ERROR: The variable created is NOT an array (${__T_ERROR}) ($?)."
                fi
            else
                __tlogte " ERROR: Cannot check for variable created (${__T_ERROR}) ($?)."
            fi
        else
            __tlogte " ERROR: __T_ARRAYNAME('${__T_ARRAYNAME}') != __TE_ARRAYNAME('${__TE_ARRAYNAME}') (${__T_ERROR}) ($?)."
        fi
    else
        __tlogte $?
    fi
else
    declare -i __T_ERROR=$?
    __tlogte "ERROR: Cannot get the future name of the array before starting the test (${__T_ERROR})."
fi

####
#
# - __trap_signal_array_delete
__tlogfs __trap_signal_array_delete
__tlogts "Error 2"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_array_delete; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 2 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 3"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_array_delete SIGINVALID; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 3 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Error 3 (number only)"
unset __T_ERROR
unset -n __T_ERROR
if __trap_signal_array_delete 1337; then
    __tlogte $?
else
    declare -i __T_ERROR=$?
    if [[ ${__T_ERROR} -eq 3 ]]; then
        __tlogtp ${__T_ERROR}
    else
        __tlogte ${__T_ERROR}
    fi
fi

__tlogts "Valid array, created then deleted."
unset __T_ERROR __T_ARRAYNAME __T_SIGNALNAME
unset -n __T_ERROR __T_ARRAYNAME __T_SIGNALNAME
declare __T_ARRAYNAME=""
declare __T_SIGNALNAME="SIGWINCH"
if __trap_signal_arrayname_get "${__T_SIGNALNAME}" __T_ARRAYNAME; then
    unset "${__T_ARRAYNAME}"
    if __trap_signal_array_create "${__T_SIGNALNAME}"; then
        if __trap_signal_array_delete "${__T_SIGNALNAME}"; then
            declare -i __T_ERROR=$?
            if declare -p "${__T_ARRAYNAME}" >/dev/null 2>&1; then
                __tlogte " ERROR: Array exists and wasn't deleted (${__T_ERROR}) ($?)."
            else
                __tlogtp ${__T_ERROR}
            fi
        else
            __tlogte " ERROR: Could not delete array ($?)."
        fi
    else
        __tlogte " ERROR: Could not create array ($?)."
    fi
else
    __tlogte " ERROR: Could not get future array name ($?)."
fi

####
#
# - __trap_signal_registered
#
__tlogfs __trap_signal_registered

__tlogts "Error 102"
__tlogtsig 102 __trap_signal_registered

__tlogts "Error 103"
__tlogtsig 103 __trap_signal_registered SIGINVALID

__tlogts "Existing signal not registered."
__tlogtsig 1 __trap_signal_registered SIGWINCH

__tlogts "Existing signal registered."
trap -- SIGWINCH
trap "__trap_run blehblubb" SIGWINCH
__tlogtsig 0 __trap_signal_registered SIGWINCH
trap -- SIGWINCH

#####
#
# - __trap_signal_register
#
__tlogfs __trap_signal_register
__tlogts "Error 102"
__tlogtsig 102 __trap_signal_register

__tlogts "Error 103"
__tlogtsig 103 __trap_signal_register SIGINVALID

__tlogts "Valid signal, can be registered."
if __trap_signal_register SIGWINCH; then
    if __trap_signal_registered SIGWINCH; then
        __tlogtp
    else
        __tlogte "Could not verify if the signal was registered or not ($?)."
    fi
else
    __tlogte "Could not register the signal in the first place ($?)."
fi

#####
#
# - __trap_signal_unregister
#
__tlogfs __trap_signal_unregister
__tlogts "Error 2"
__tlogtsig 2 __trap_signal_unregister

__tlogts "Error 3"
__tlogtsig 3 __trap_signal_unregister "SIGINVALID"

__tlogts "Error 3 (digits)"
__tlogtsig 3 __trap_signal_unregister 666

__tlogts "Valid signal, registered first, then unregistered."
unset __T_ERROR __TE_SIGNALNAME
unset -n __T_ERROR __TE_SIGNALNAME
declare __TE_SIGNALNAME="SIGWINCH"
if __trap_signal_register "${__TE_SIGNALNAME}"; then
    if __trap_signal_registered "${__TE_SIGNALNAME}"; then
        if __trap_signal_unregister "${__TE_SIGNALNAME}"; then
            declare -i __T_ERROR=$?
            if __trap_signal_registered "${__TE_SIGNALNAME}"; then
                __tlogte "Should be unregistered, but is registered. That's odd (${__T_ERROR}) ($?)."
            else
                __tlogtp ${__T_ERROR}
            fi
        else
            __tlogte "Could not unregister the signal ($?)."
        fi
    else
        __tlogte "The signal isn't reported as being registered ($?)."
    fi
else
    __tlogte "Could not register the signal in the first place ($?)."
fi

#####
#
# - __trap_function_registered
#
__tlogfs __trap_function_registered
__tlogts "Error 101"
__tlogtsig 101 __trap_function_registered

__tlogts "Error 102"
__tlogtsig 102 __trap_function_registered SIGINVALID

__tlogts "Error 102 (Digits)"
__tlogtsig 102 __trap_function_registered 666

__tlogts "Error 103"
__tlogtsig 103 __trap_function_registered SIGWINCH

__tlogts "Valid Function, Valid Arrayname, Everything exists, should not error out."
unset __T_ERROR __TE_ERROR __TE_ARRAYNAME __TE_FUNCTIONNAME __TE_SIGNALNAME
unset -n __T_ERROR __TE_ERROR __TE_ARRAYNAME __TE_FUNCTIONNAME __TE_SIGNALNAME
declare -i __T_ERROR=0
declare -i __TE_ERROR=0
declare __TE_ARRAYNAME=""
declare __TE_FUNCTIONNAME="__test_function_name"
declare __TE_SIGNALNAME="SIGWINCH"
if __trap_signal_arrayname_get "${__TE_SIGNALNAME}" __TE_ARRAYNAME; then
    if unset "${__TE_ARRAYNAME}"; then
        if declare -agx "${__TE_ARRAYNAME}=("${__TE_FUNCTIONNAME}")"; then
            if __trap_function_registered "${__TE_SIGNALNAME}" "${__TE_FUNCTIONNAME}"; then
                __tlogtp $?
            else
                __tlogte $?
            fi
        else
            __tlogte "Could not declare array to test ($?)."
        fi
    else
        __tlogts "Could not unset array to recreate it ($?)."
    fi
else
    __tlogte "Couldn't get the arrayname in the first place ($?)."
fi
unset "${__TE_ARRAYNAME}"

__tlogts "Invalid Function, Valid Arrayname, should error out."
unset __T_ERROR __TE_ERROR __TE_ARRAYNAME __TE_FUNCTIONNAME __TE_SIGNALNAME
unset -n __T_ERROR __TE_ERROR __TE_ARRAYNAME __TE_FUNCTIONNAME __TE_SIGNALNAME
declare -i __T_ERROR=0
declare -i __TE_ERROR=0
declare __TE_ARRAYNAME=""
declare __TE_FUNCTIONNAME="__test_function_name"
declare __TE_SIGNALNAME="SIGWINCH"
if __trap_signal_arrayname_get "${__TE_SIGNALNAME}" __TE_ARRAYNAME; then
    if unset "${__TE_ARRAYNAME}"; then
        if declare -agx "${__TE_ARRAYNAME}=("${__TE_FUNCTIONNAME}")"; then
            if __trap_function_registered "${__TE_SIGNALNAME}" __test_invalid_function_name; then
                __tlogte $?
            else
                declare -i __T_ERROR=$?
                if [[ ${__T_ERROR} -eq 1 ]]; then
                    __tlogtp ${__T_ERROR}
                else
                    __tlogte ${__T_ERROR}
                fi
            fi
        else
            __tlogte "Could not declare array to test ($?)."
        fi
    else
        __tlogts "Could not unset array to recreate it ($?)."
    fi
else
    __tlogte "Couldn't get the arrayname in the first place ($?)."
fi
unset "${__TE_ARRAYNAME}"

__tlogts "Valid functionname but array is missing. Should error out."
__tlogtsig 111 __trap_function_registered SIGWINCH __test_function_name

#####
#
# - __trap_function_register
#

__tlogfs __trap_function_register

__tlogts "Error 101"
__tlogtsig 101 __trap_function_register

__tlogts "Error 102"
__tlogtsig 102 __trap_function_register SIGINVALID

__tlogts "Error 102 (Digits)"
__tlogtsig 102 __trap_function_register 666

__tlogts "Error 103"
__tlogtsig 103 __trap_function_register SIGWINCH

__tlogts "Signal exists, function exists. Should work."
unset __T_ERROR
unset -n __T_ERROR
function __test_function_name() {
    return 0
}

__tlogtsig 0 __trap_function_register SIGWINCH __test_function_name
unset -f __test_function_name

__tlogts "Signal exists, function not. Should error out."
__tlogtsig 113 __trap_function_register SIGWINCH __test_invalid_function_name

__tlogts "Signal exists, function too, but will be added twice and should error out."

function __test_function_name_123() { echo "0"; return 0; }

if __trap_function_register SIGWINCH __test_function_name_123; then
    __tlogtsig 112 __trap_function_register SIGWINCH __test_function_name_123
else
    __tlogte "Could not register the function to provoke the error ($?)."
fi

unset -f __test_function_name_123


#####
#
# - __trap_function_unregister
#
__tlogfs __trap_function_unregister
__tlogts "Error 101"
__tlogtsig 101 __trap_function_unregister

__tlogts "Error 102"
__tlogtsig 102 __trap_function_unregister SIGINVALID

__tlogts "Error 102 (digits)"
__tlogtsig 102 __trap_function_unregister 666

__tlogts "Error 103"
__tlogtsig 103 __trap_function_unregister SIGWINCH

__tlogts "Unregister existing function from existing signal."
function __test_function_name_124() { echo "${FUNCNAME[0]}"; return 0; }
if __trap_function_register SIGWINCH __test_function_name_124; then
    if __trap_function_registered SIGWINCH __test_function_name_124; then
        if __trap_function_unregister SIGWINCH __test_function_name_124; then
            __tlogtp $?
        else
            __tlogte $?
        fi
    else
        __tlogte "Could not check if the function was registered successfully ($?)."
    fi
else
    __tlogte "Could not register the function in the first place ($?)."
fi

__tlogts "Unregister non existing function from existing signal."
function __test_function_name_125() { echo "${FUNCNAME[0]}"; return 0; }
if __trap_function_register SIGWINCH __test_function_name_125; then
    if __trap_function_unregister SIGWINCH __test_invalid_function_name; then
        __tlogte $?
    else
        __tlogtp $?
    fi
else
    __tlogte "Could not register a function in the first place ($?)."
fi

#####
#
# - __trap_run
#
__tlogfs __trap_run
__tlogts "Error 101"
__tlogtsig 101 __trap_run

__tlogts "error 102"
__tlogtsig 102 __trap_run SIGINVALID

__tlogts "Error 102 digits"
__tlogtsig 102 __trap_run 666

__tlogts "Error 103"
__tlogtsig 103 __trap_run SIGRTMIN

__tlogts "Valid function, signal and off we go..."
function __test_function_name_130() { return 0; }
if __trap_function_register SIGRTMIN __test_function_name_130; then
    if __trap_run SIGRTMIN; then
        __tlogtp $?
    else
        __tlogte $?
    fi
else
    __tlogte "Could not register function in the first place."
fi

__tlogfe
__tlogle
