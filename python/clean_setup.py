from os import sep
import sys
import re as pattern
from termcolor import colored

groupNames = []
aliasList = []
aliasCommands = []
genLine = "#"
wildCardList = ["source, sudo"]



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


def is_command(commandToCheck):
    from shutil import which
    return which(commandToCheck) is not None


def check_line(slicedLine, command, index):
    if not slicedLine not in aliasList:
        print(colored("found duplicate versions of alias: {}".format(slicedLine), 'red'))
        return False
    elif not command not in aliasCommands:
        print(colored("dangerous alias embedding in line:{} {} --> alias '{}' already exists"
                      .format(index, slicedLine, command), 'red'))
        return False
    elif is_command(get_alias(slicedLine)):
        print(colored("Line {}, given alias also a valid command => Conflict: {}"
                      .format(index, get_alias(slicedLine)), 'red'))
        return False
    elif not get_alias(slicedLine) not in aliasCommands:
        print(colored("Found duplicate Alias in line:{} {}".format(index, get_alias(slicedLine)), 'red'))
        return False
    else:
        if command not in groupNames:
            groupNames.append(command)
        aliasCommands.append(get_alias(slicedLine))
        aliasList.append(slicedLine)
        return True


def file_check(text_content):
    errorCounter = int(0)
    groupPattern = pattern.compile("\[(.*?)\]")
    aliasPattern = pattern.compile("alias (.*?)\S='\S(.*?)'")

    splittedText = text_content.split('\n')

    for index, line in enumerate(splittedText, start=1):
        if aliasPattern.match(line) or groupPattern.match(line) or line.startswith(genLine):
            if aliasPattern.match(line):
                slicedLine = slice_line(line.strip(), "'", 2)
                command = get_command(slicedLine)
                if is_command(command) or command in wildCardList:
                    errorCounter += 0 if check_line(slicedLine, command, index) else 1
                else:
                    print(colored("command '{}' not found on local-system".format(command), 'red'))
                    errorCounter += 1
        elif line.strip():
            print(colored("Removing line {}: {}  due to wrong pattern".format(index, line), 'red'))
            errorCounter += 1

    return errorCounter


def sort_alphabetically(arr):
    return sorted(arr, key=str.lower)


def verify(path, groupNames):
    print("\n🔎  checking alias-file: {}\n".format(path))

    with open(path, "r") as aliasrc:
        errorCounter = file_check(aliasrc.read())

    setup(path, True, groupNames)

    if errorCounter == 0:
        print("    No errors detected 	\u2705")
    else:
        print("\n    Found {} error(s)".format(errorCounter))

    print("\n    Check completed\n")
    print("----------------------\n")

    print("ℹ️   Gathering information...\n")

    print(colored("Command Groups: ", 'green'), *groupNames, sep='|')
    print(colored("Total Aliases:", 'green'), len(aliasList))
    print(colored("Aliases:", 'green'), *aliasCommands, sep="|")


def structured_writer(f, al, com):
    TGREEN = '\033[32m'  # Green Text
    TWHITE = '\033[37m'
    for command in com:
        f.write("\n[" + TGREEN + " -- " + command + " -- " + TWHITE + "]", )
        for alias in al:
            if get_command(alias) == command:
                f.write("\n" + alias + "\n")


def setup(path, isVerified, groupNames):
    with open(path, "r+") as aliasrc:
        if not isVerified:
            for index, line in enumerate(aliasrc.read().split("\n"), start=0):
                if line.startswith("alias") or line.startswith(genLine) and get_command(line) != "'":
                    aliasList.append(line)
                    groupNames.append(get_command(line) if isinstance(get_command(line), str) and get_command(
                        line) not in groupNames else "")
        groupNames = sort_alphabetically(filter(None, groupNames))
        aliasrc.truncate(0)
        structured_writer(aliasrc, aliasList, groupNames)


def switcher(args):
    if args[2] == "verify":
        verify(args[1], groupNames)
    elif args[2] == "light-setup":
        setup(args[1], False, groupNames)
    else:
        print("unknown flag: " + args[2])


switcher(sys.argv if len(sys.argv) > 1 else sys.exit(-666))
