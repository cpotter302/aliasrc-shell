import sys 

def create_command_and_alias_groups(alias_block):
    ALIAS = "alias"
    if alias_block.startswith(ALIAS):
        print(alias_block)
def main():
    print("--------------------\nin python:")
    print(sys.argv[1])
    print(sys.argv[2])
    with open("/home/carlo/.bash_aliases", "r") as aliasrc:
        for line in aliasrc:
            create_command_and_alias_groups(line)
main() 