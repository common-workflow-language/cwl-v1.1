#!/bin/bash

read -rd "\000" helpmessage <<EOF
$(basename $0): Run common workflow tool description language conformance tests.

Syntax:
        $(basename $0) [RUNNER=/path/to/cwl-runner]
                       [EXTRA=--optional-arguments-to-cwl-runner]

Options:
  -ntest_range          Run specific test(s) by number (format "1,2-4,7")
  -Ntest_range          Exclude specific test(s) by number (format "1,2-4,7")
  -stest_names          Run specific test(s) by name (format "test_a,test_b")
  -Stest_names          Exclude specific test(s) by name (format "test_a,test_b")
  -l                    List tests
  -jJ                   Specifies the number of tests to run simultaneously
                        (defaults to one).
  --only-tools          Only test CommandLineTools
  --junit-xml=FILENAME  Store results in JUnit XML format using the given
                        FILENAME
  --classname=CLASSNAME In the JUnit XML, tag the results with the given
                        CLASSNAME
  --verbose             Print the cwltest invocation and pass --verbose to
                        cwltest

Note:
  EXTRA is useful for passing --enable-dev to the CWL reference runner:
  Example: RUNNER=cwltool EXTRA=--enable-dev
EOF

TEST_n=""
TEST_N=""
TEST_s=""
TEST_S=""
JUNIT_XML=""
RUNNER=cwl-runner
PLATFORM=$(uname -s)
COVERAGE="python"
EXTRA=""
CLASS=""
VERBOSE=""

while [[ -n "$1" ]]
do
    arg="$1"; shift
    case "$arg" in
        --help)
            echo >&2 "$helpmessage"
            echo >&2
            exit 1
            ;;
        -n*)
            TEST_n=$arg
            ;;
	-N*)
	    TEST_N=$arg
	    ;;
        -s*)
            TEST_s=$arg
            ;;
	-S*)
	    TEST_S=$arg
	    ;;
        -j*)
            TEST_J=$arg
            ;;
        -l)
            TEST_L=-l
            ;;
        --only-tools)
            ONLY_TOOLS=$arg
            ;;
        --junit-xml=*)
            JUNIT_XML=$arg
            ;;
        --classname=*)
            CLASS=$arg
            ;;
        --verbose)
            VERBOSE=$arg
            ;;
        *=*)
            eval $(echo $arg | cut -d= -f1)=\"$(echo $arg | cut -d= -f2-)\"
            ;;
    esac
done

if ! runner="$(which $RUNNER)" ; then
    echo >&2 "$helpmessage"
    echo >&2
    echo >&2 "runner '$RUNNER' not found"
    exit 1
fi

runs=0
failures=0

checkexit() {
    if [[ "$?" != "0" ]]; then
        failures=$((failures+1))
    fi
}

runtest() {
    echo "--- Running CWL Conformance Tests on $1 ---"

    "$1" --version

    runs=$((runs+1))
    (COMMAND="cwltest --tool $1 \
	     --test=conformance_tests.yaml ${CLASS} \
	     ${TEST_n} ${TEST_N} ${TEST_s} ${TEST_S} \
	     ${VERBOSE} ${TEST_L} ${TEST_J} ${ONLY_TOOLS} ${JUNIT_XML} \
	     -- ${EXTRA}"
     if [[ $VERBOSE == "--verbose" ]]; then echo ${COMMAND}; fi
     ${COMMAND}
    )
    checkexit
}

if [[ $PLATFORM == "Linux" ]]; then
    runtest "$(readlink -f $runner)"
else
    runtest "$(greadlink -f $runner)"
fi

if [[ -n "$TEST_L" ]] ; then
   exit 0
fi

# Final reporting

echo

exit $failures
