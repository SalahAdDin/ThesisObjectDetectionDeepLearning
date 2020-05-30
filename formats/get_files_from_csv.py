import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("-p","--path", help="File path")  # File path
args = parser.parse_args()

if __name__ == "__main__":
    """
    Use:
        python make_val.py -p file.txt -n #
    """

    print("Analyzing {}".format(args.path))

    # raw = open(args.path, "r").readlines()
    # lines= []

    # for line in raw[1:]:
    #     lines.append(line.split(".")[0])

    # file_name = args.path.replace(".csv", ".txt")
    # with open("train.txt", "w") as output:
    #     for line in lines:
    #         output.write(str(line)+'\n')

    file_name = args.path.split("_")[0] + ".txt"
    with open(file_name, "w") as output: 
        for r, d, f in os.walk(args.path):
            for file in f:   
                output.write(str(file.split(".")[0])+'\n')

