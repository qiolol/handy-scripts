#!/usr/bin/env bash
# runs the executable $1 until it returns with a non-0 exit status, and,
# when it fails, prints the executable's stdout output, stderr output,
# and exit status, and then exits with that exit status

# checks args and reads in the number of times to run
function parse_input() {
    # correct number of args
    if [[ "${#}" -le 2 ]]
    then
        # correct arg format
        if [[ "${#}" = 2 && "${2}" =~ ^[1-9][0-9]*$ || "${#}" = 1 ]]
        then
            if [[ "${#}" = 2 ]]
            then
                readonly RUN_LIMIT="${2}"
            else
                readonly RUN_LIMIT=999 # run 999 times by default
            fi
            
            return 0
        fi
    fi
    
    return 1
}

function print_usage() {
    echo "usage: run_exe_until_fail <executable> [times]"
    echo -e "\nruns executable the given number of times (or 999 times if unspecified)"
}

# runs $1 until it fails
function run_exe_until_fail()
{
    for (( RUN_COUNT = 1; RUN_COUNT <= RUN_LIMIT; ++RUN_COUNT ))
    do
        echo -ne "\rRun #${RUN_COUNT}... "
    
        if EXE_OUTPUT="$("${1}" 2>&1)"; then
            : # Do nothing here cuz inverting the conditional would make 
              # us lose the exit status.
        else
            local EXE_EXIT_STATUS="${?}"
            
            echo "exe failed with exit code ${EXE_EXIT_STATUS}!"
            echo "==== exe output start =========================================================="
            echo "${EXE_OUTPUT}"
            echo "============================================================ exe output end ===="
            exit "${EXE_EXIT_STATUS}"
        fi
    done
    echo ""
}

if parse_input "${@}"
then
    run_exe_until_fail "${1}"
    echo "No failure after ${RUN_LIMIT} runs."
    
    exit 0
else
    print_usage
    
    exit 1
fi

# For example, call this with something like this Python script:
# #!/usr/bin/env python3
# import random
# import sys
# import time
# 
# def coinFlip():
#     return random.choice([True, False])
# 
# if coinFlip() == True:
#     print("(STDOUT) exec success")
#     time.sleep(1)
#     sys.exit(0)
# else:
#     print("(STDOUT) exec FAIL")
#     sys.stdout.flush()
#     sys.stderr.write("(STDERR) failure info...")
#     sys.stderr.flush()
#     sys.exit(1)
