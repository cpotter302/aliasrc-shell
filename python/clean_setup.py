import sys
import re as pattern
from termcolor import colored

groupNames = []
aliasList = []
aliasCommands = []


def get_command(string):
    return string.replace(slice(string, "'", 1), "").split(" ")[0]


def get_alias(string):
    return slice(string, "=", 1).replace("alias", "").replace("=", "").strip()


def slice(text, char, occur):
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
        print(colored("Line {}, given alias also a valid command => Conflict:{} is ".format(index, get_alias(slicedLine)), 'red'))
        return False
    elif not get_alias(slicedLine) not in aliasCommands:
        print(colored("Found duplicate Alias in line:{} {}".format(index, get_alias(slicedLine)), 'red'))
        return False
    else:
        if command not in groupNames:
            groupNames.append(command)
        aliasCommands.append(get_alias(slicedLine))
        aliasList.append(slicedLine)


def file_check(text_content):
    groupPattern = pattern.compile("\[(.*?)\]")
    aliasPattern = pattern.compile("alias (.*?)\S='\S(.*?)'")

    splittedText = text_content.split('\n')

    for index, line in enumerate(splittedText, start=1):
        if aliasPattern.match(line) or groupPattern.match(line):
            if aliasPattern.match(line):
                slicedLine = slice(line.strip(), "'", 2)
                command = get_command(slicedLine)
                if is_command(command):
                    check_line(slicedLine, command, index)
                else:
                    print(colored("command '{}' not found on local-system".format(command), 'red'))
        elif line.strip():
            print(colored("Removing line {}: {}  due to wrong pattern".format(index, line), 'red'))


def light_setup(path): 
    print("Hello from light")

def setup(path):
    print("🔎   checking alias-file")

    with open(path, "r") as aliasrc:
        file_check(aliasrc.read())

    print("\nfrom {}".format(__name__))
    print("ℹ️   Check completed")
    print("Command Groups: {}".format(groupNames))
    print("Aliases: {}".format(aliasList))
    print("Aliases Groups: {}".format(aliasCommands))


def insert(path):
    print("Hello frm insert", path)




def switcher(args): 
    if args[2] == "setup":
        setup(args[1])
    elif args[2] == "insert":
        insert(args[1])
    else:
        light_setup(args[1])


switcher(sys.argv if len(sys.argv) > 1 else sys.exit(-666))
