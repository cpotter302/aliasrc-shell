import sys


def log_argv(argv):
    for x in range(1, len(argv)):
        print(argv[x])


def execute_task(operation):
    # setup("../resources/.bash_aliases.back")
    switcher = {
        "insert": log_argv(sys.argv)
    }
    switcher.get(operation, "No operation found")


execute_task(sys.argv[1])
