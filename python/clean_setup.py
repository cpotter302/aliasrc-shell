import re as pattern
import sys
from termcolor import colored
from subprocess import check_output

groupNames = []
aliasList = []
aliasCommands = []
genLine = "#"

# commands = str(check_output('compgen -c', shell=True, executable='/bin/bash'))
wildCardList = ["sudo", "cd", "file", "mv", "cp"]
# commands[2:].split("\\n")[:-1]


def get_command(string):
    return string.replace(slice_line(string, "'", 1), "").split(" ")[0]


def get_alias(string):
    return slice_line(string, "=", 1).replace("alias", "").replace("=", "").strip()


def slice_line(text, char, occur):
    string = ""
    counter = 0
    for c in range(len(text)):
        if counter != occur:
            string += text[c]
            if text[c] == char:
                counter = counter + 1
    return string.strip()


def is_command(command_to_check):
    from shutil import which
    return which(command_to_check) is not None


def check_line(sliced_line, command, index):
    if not sliced_line not in aliasList:
        print(colored("found duplicate versions of alias: {}".format(sliced_line), 'red'))
        return False
    elif not command not in aliasCommands:
        print(colored("dangerous alias embedding in line:{} {} --> alias '{}' already exists"
                      .format(index, sliced_line, command), 'red'))
        return False
    elif is_command(get_alias(sliced_line)):
        print(colored("Line {}, given alias also a valid command => Conflict: {}"
                      .format(index, get_alias(sliced_line)), 'red'))
        return False
    elif not get_alias(sliced_line) not in aliasCommands:
        print(colored("Found duplicate Alias in line:{} {}".format(index, get_alias(sliced_line)), 'red'))
        return False
    else:
        if command not in groupNames:
            groupNames.append(command)
        aliasCommands.append(get_alias(sliced_line))
        aliasList.append(sliced_line)
        return True


def file_check(text_content):
    error_counter = int(0)
    group_pattern = pattern.compile("\[(.*?)\]")
    alias_pattern = pattern.compile("alias (.*?)\S='\S(.*?)'")

    splitted_text = text_content.split('\n')

    for index, line in enumerate(splitted_text, start=1):
        if alias_pattern.match(line) or group_pattern.match(line) or line.startswith(genLine):
            if alias_pattern.match(line):
                sliced_line = slice_line(line.strip(), "'", 2)
                command = get_command(sliced_line)
                if is_command(command) or command in wildCardList:
                    error_counter += 0 if check_line(sliced_line, command, index) else 1
                else:
                    error_counter += 0 if check_line(sliced_line, command, index) else 1
                    print(colored("command '{}' not found on local-system".format(command), 'red'))
                    print("Line: {} ->\t{}\n".format(index + 1, str(line)))
                    error_counter += 1
        elif line.strip():
            print(colored("Removing line {}: {}  due to wrong pattern".format(index, line), 'red'))
            error_counter += 1

    return error_counter


def sort_alphabetically(arr):
    return sorted(arr, key=str.lower)


def verify(path, gn):
    print("\n🔎  checking alias-file: {}\n".format(path))

    with open(path, "r") as aliasrc:
        error_counter = file_check(aliasrc.read())

    setup(path, True, gn)

    if error_counter == 0:
        print("    No errors detected 	\u2705")
    else:
        print("\n    Found {} error(s)".format(error_counter))

    print("\n    Check completed\n")
    print("----------------------\n")

    print("ℹ️   Gathering information...\n")

    print(colored("Command Groups: ", 'green'), *gn, sep='|')
    print(colored("Total Aliases:", 'green'), len(aliasList))
    print(colored("Aliases:", 'green'), *aliasCommands, sep="|")


def structured_writer(f, al, com):
    tgreen = '\033[32m'  # Green Text
    twhite = '\033[37m'
    for command in com:
        f.write("\n" + genLine + "[" + tgreen + " -- " + command + " -- " + twhite + "]", )
        for alias in al:
            if get_command(alias) == command:
                f.write("\n" + alias + "\n")


def setup(path, is_verified, gn):
    with open(path, "r+") as aliasrc:
        if not is_verified:
            for index, line in enumerate(aliasrc.read().split("\n"), start=0):
                if line.startswith("alias") or line.startswith(genLine) and get_command(line) != "'":
                    aliasList.append(line)
                    gn.append(get_command(line) if isinstance(get_command(line), str) and get_command(
                        line) not in gn else "")
        gn = sort_alphabetically(filter(None, gn))
        aliasrc.truncate(0)
        structured_writer(aliasrc, aliasList, gn)


def switcher(args):
    if args[2] == "verify":
        verify(args[1], groupNames)
    elif args[2] == "light-setup":
        setup(args[1], False, groupNames)
    else:
        print("unknown flag: " + args[2])


switcher(sys.argv if len(sys.argv) > 1 else sys.exit(-666))
