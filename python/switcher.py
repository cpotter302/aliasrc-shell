import sys
from python.clean_setup import verify
import python.operations.som as som_operator


def log_argv(argv, operate):
    print("\nfrom switcher.py")
    for x in range(1, len(argv)):
        print(argv[x])
    som_operator.sort()
    operate()
    som_operator.manipulate()
    sys.exit(0)


def execute_task(operation):
    verify()
    
    switcher = {
        "insert": log_argv(sys.argv, som_operator.insert_alias),
        "deleteA": log_argv(sys.argv, som_operator.del_alias),
        "deleteG": log_argv(sys.argv, som_operator.del_group)
    }
    switcher.get(operation, "No operation found")


execute_task(sys.argv[1]) if len(sys.argv) > 1 else sys.exit(666)
