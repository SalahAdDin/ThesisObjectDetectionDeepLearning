import argparse
import re
import sys
import matplotlib.pyplot as plt

# from collections import defaultdict

# python plotTFTrainLoss.py -p retinanet_mango_yolo.log -s 500


parser = argparse.ArgumentParser()
parser.add_argument("-p", "--path", help="Log file path")  # log file path
parser.add_argument("-s", "--steps", type=int,
                    help="Step's number")  # step's number
args = parser.parse_args()

path = args.path
steps = args.steps

lines = []
avg_loss = []
f1_score = []
epoch_number = []
# epochs = defaultdict(dict)


print('Retrieving epochs data and plotting training loss graph...')
for line in open(path):
    if "Epoch" in line and not "Epoch 0" in line:
        epoch_number.append(int(line.split(" ")[1].split("/")[0]))
    if "mAP" in line:
        mAP = float(line.split(" ")[1])
        # epochs[epoch_number]['mAP'] = mAP
        avg_loss.append(mAP)
    if "mF1" in line:
        mF1 = float(line.split(" ")[1])
        # epochs[epoch_number]['mF1'] = mF1
        f1_score.append(mF1)
    if "/"+str(steps) in line:
        line = re.sub('\x08', '', line)
        lines.append(line.replace('\n', ''))

fig = plt.figure()
plt.plot(epoch_number, avg_loss, label="Average Loss")
plt.plot(epoch_number, f1_score, label="F1 Score")
plt.xlabel('Epochs')
plt.title('Performance development by Epochs')
plt.legend()

figure_name = path.replace(".log", "_summary.png")
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as ' + figure_name)

iterations = range(0, int(steps)*len(epoch_number))


loss = []
regression_loss = []
classification_loss = []

print('Retrieving steps data and plotting training loss graph...')
for i in range(len(lines)):
    lineParts = lines[i].split('-')
    loss.append(float(lineParts[2].split(': ')[1]))
    regression_loss.append(float(lineParts[3].split(': ')[1]))
    classification_loss.append(float(lineParts[4].split(': ')[1]))

fig = plt.figure()

plt.plot(iterations, loss, label="Loss")
plt.plot(iterations, regression_loss, label="Regression Loss")
plt.plot(iterations, classification_loss, label="Classification Loss")
plt.xlabel('Epochs')
plt.title('Performance development by Steps')
plt.legend()

figure_name = path.replace(".log", "_steps.png")
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as ' + figure_name)
