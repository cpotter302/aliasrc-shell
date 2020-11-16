import sys
import re as pattern
from termcolor import colored

groupNames = []

get_command = lambda string: string.replace(slice(string, "'", 1), "").split(" ")[0]

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
    if len(commandToCheck.split(" ")) == 1:
        return which(commandToCheck) is not None
    else:
        return which(get_command(commandToCheck)) is not None


def file_check(text_content):
    groupPattern = pattern.compile("\[(.*?)\]")
    aliasPattern = pattern.compile("alias (.*?)\S='\S(.*?)'")
    aliasList = []

    for index, line in enumerate(text_content.split('\n'), start=1):
        if aliasPattern.match(line) or groupPattern.match(line):
            if aliasPattern.match(line):
                slicedLine = slice(line.strip(), "\'", 2)
                command = get_command(slicedLine)
                if is_command(slicedLine):
                    if slicedLine not in aliasList:
                        aliasList.append(slicedLine)
                    else:
                        print(colored("found duplicate versions of alias: {}".format(slicedLine), 'red'))
                    if command not in groupNames:
                        groupNames.append(command)
                else:
                    print(colored("command '{}' not found on local-system".format(command), 'red'))
        elif line.strip():
            print(colored("Removing line {}: {}  due to wrong pattern".format(index, line), 'red'))

    return aliasList


def main():
    # print(sys.argv[1])
    # print(sys.argv[2])
    print("🔎   checking alias-file")
    mainList = []
    
    with open(".bash_aliases.back", "r") as aliasrc:
        mainList = file_check(aliasrc.read())
    print("ℹ️   Check completed")
    print("-----------------\nFile infos:")
    print("Alias Groups: {}".format(groupNames))
    print("Aliases: {}".format(mainList))

    # file operations come here
    # setup file operations based on switch statements, new file for flags and writing operation


main()
