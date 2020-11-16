import sys
import re as pattern
from termcolor import colored

groupNames = []
aliasNamees = []
aliasList = []
aliasCommands = []

get_command = lambda string: string.replace(slice(string, "'", 1), "").split(" ")[0]
get_alias = lambda string: slice(string, "=", 1).replace("alias", "").replace("=", "").strip()

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
        print(colored("found dangerous alias embedding in line:{} {}".format(index, slicedLine), 'red'))
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
                    check_line(slicedLine, command,index)
                else:
                    print(colored("command '{}' not found on local-system".format(command), 'red'))
        elif line.strip():
            print(colored("Removing line {}: {}  due to wrong pattern".format(index, line), 'red'))
    
    


def setup():
    # print(sys.argv[1])
    # print(sys.argv[2])
    print("🔎   checking alias-file")
    
    with open("../resources/.bash_aliases.back", "r") as aliasrc:
        file_check(aliasrc.read())
    print("ℹ️   Check completed")
    print("-----------------\nFile infos:")
    print("Command Groups: {}".format(groupNames))
    print("Aliases: {}".format(aliasList))
    print("Aliases Groups: {}".format(aliasCommands))

    # file operations come here
    # setup file operations based on switch statements, new file for flags and writing operation

setup()
