import sys
import re as pattern
from termcolor import colored

groupNames = []


def slice(text, char, occur):
    string = ""
    counter = 0
    for c in range(len(text)):
        if counter != occur:
            string += text[c]
            if text[c] == char:
                counter = counter + 1
    return string.strip()


def get_command(string):
    slicer = string.replace(slice(string, "'", 1), "")
    return slicer.split(" ")[0]


def is_command(commandToCheck):
    from shutil import which
    if len(commandToCheck.split(" ")) == 1:
        return which(commandToCheck) is not None
    else:
        return which(get_command(commandToCheck)) is not None


def create_command_and_alias_groups(text_content):
    ALIAS = "alias"
    print(text_content)


def file_check(text_content):
    groupPattern = pattern.compile("\[(.*?)\]")
    aliasPattern = pattern.compile("alias (.*?)\S='\S(.*?)'")
    aliasList = []
    for line in text_content.split('\n'):
        if aliasPattern.match(line) or groupPattern.match(line):
            if aliasPattern.match(line):
                slicedLine = slice(line.strip(), "\'", 2)
                command = get_command(slicedLine)
                if is_command(slicedLine):
                    if slicedLine not in aliasList:
                        aliasList.append(slicedLine)
                    if command not in groupNames:
                        groupNames.append(command)
                    print(aliasList)
                else:
                    print(colored("command: {} not found on local-system".format(command), 'red'))
        else:
            print(colored("Removing line: *{}* due to wrong pattern".format(line), 'red'))

    print(groupNames)


def main():
    # print(sys.argv[1])
    # print(sys.argv[2])
    with open("../test/.bash_aliases", "r") as aliasrc:
        file_check(aliasrc.read())
    # create_command_and_alias_groups(aliasrc.read())
    # file operations come here


main()
