import sys
from python.cleanSetup import setup


def log_argv(argv):
    print("\nfrom switcher.py")
    for x in range(1, len(argv)):
        print(argv[x])
    sys.exit(0)


def execute_task(operation):
    setup("../resources/.bash_aliases.back")
    switcher = {
        "insert": log_argv(sys.argv),
        "delete": log_argv(sys.argv)
    }
    switcher.get(operation, "No operation found")


execute_task(sys.argv[1]) if len(sys.argv) > 1 else sys.exit(666)
