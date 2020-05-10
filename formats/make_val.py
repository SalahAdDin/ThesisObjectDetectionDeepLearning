import argparse
import random

parser = argparse.ArgumentParser()
parser.add_argument("-p","--path", help="File path")  # File path
parser.add_argument("-n", "--number", type=int, default='50', help="Number of items") # Number of items for new file
args = parser.parse_args()

def make_file(files_list, n_items):
    """ Compute the average precision, given the recall and precision curves.
    Code originally from https://github.com/rbgirshick/py-faster-rcnn.
    # Arguments
        file:    Train file or required source file.
        elements: Number of required files for the new file.
    # Returns
        val: A list with the n random files.
        train: A list without those n random files.
    """

    val = random.sample(files_list, n_items)
    train = files_list

    for item in val:
        train.remove(item)
    
    return train, val


if __name__ == "__main__":
    """
    Use:
        python make_val.py -p file.txt -n #
    """

    print("Analyzing {}".format(args.path))

    raw = open(args.path, "r").readlines()

    print("Creating training and validation values")
    train, val = make_file(raw, args.number)

    print("Printing training file.")
    with open("train.txt", "w") as output:
        for row in train:
            output.write(str(row))

    print("Printing validation file.")
    with open("val.txt", "w") as output:
        for row in val:
            output.write(str(row))
