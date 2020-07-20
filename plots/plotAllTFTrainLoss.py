import argparse
import os
import re
import sys
import matplotlib
import matplotlib.pyplot as plt

# from collections import defaultdict

# python plotTFTrainLoss.py -p retinanet_mango_yolo.log -s 500


parser = argparse.ArgumentParser()
parser.add_argument("-p", "--path", help="Log folder path")  # log file path
parser.add_argument("-s", "--steps", type=int,
                    help="Step's number used at training RetinaNet")  # step's number
args = parser.parse_args()

path = args.path
steps = args.steps

file_names = os.listdir(path)
names = [x.split('_')[-1].replace('.log', '') for x in file_names]
traces = [path+'/{}'.format(x) for x in file_names]
print(names)

global_lines = []

cmap = matplotlib.cm.get_cmap('Dark2')
ls = [(0, (3, 1, 1, 1, 1, 1)), '--', '-.', ':', (0, (3, 5, 1, 5, 1, 5)), ]

fig = plt.figure()
axes = fig.add_subplot(111)

for j, trace in enumerate(traces):
    print(trace)

    c = cmap(float(j)/len(traces))

    lines = []
    avg_loss = []
    f1_score = []
    epoch_number = []

    print('Retrieving epochs data and plotting training loss graph...')
    for line in open(trace):
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

    global_lines.append(lines)

    axes.plot(epoch_number, avg_loss, color=c,
              ls=ls[j], lw=.75, label=names[j])

lines = []
labels = []

for ax in fig.axes:
    axLine, axLabel = ax.get_legend_handles_labels()
    lines.extend(axLine)
    labels.extend(axLabel)

fig.legend(lines, labels,
           loc='upper right', bbox_to_anchor=(0.85, 0.85))

plt.xlabel('Epochs')
plt.ylabel("Average Accuracy")

plt.title('Performance development by Epochs')

figure_name = "all_{}_summary.png".format(str(steps))
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as ' + figure_name)


iterations = range(0, int(steps)*len(epoch_number))

losses = []
regression_losses = []
classification_losses = []

for j, trace in enumerate(traces):
    print(trace)

    loss = []
    regression_loss = []
    classification_loss = []

    lines = global_lines[j]

    print('Retrieving steps data and plotting training loss graph...')
    for i in range(len(lines)):
        lineParts = lines[i].split('-')
        loss.append(float(lineParts[2].split(': ')[1]))
        regression_loss.append(float(lineParts[3].split(': ')[1]))
        classification_loss.append(float(lineParts[4].split(': ')[1]))

    losses.append(loss)
    regression_losses.append(regression_loss)
    classification_losses.append(classification_loss)

fig = plt.figure()
axes = fig.add_subplot(111)
for i, loss in enumerate(losses):
    c = cmap(float(i)/len(traces))
    axes.plot(iterations, loss,
              color=c, ls=ls[i], lw=.75, label=names[i])

lines = []
labels = []

for ax in fig.axes:
    axLine, axLabel = ax.get_legend_handles_labels()
    lines.extend(axLine)
    labels.extend(axLabel)

fig.legend(lines, labels,
           loc='upper right', bbox_to_anchor=(0.85, 0.85))

plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Loss performance development by Steps')

figure_name = "all_loss_{}_steps.png".format(str(steps))
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as ' + figure_name)

fig = plt.figure()
axes = fig.add_subplot(111)
for i, regression_loss in enumerate(regression_losses):
    c = cmap(float(i)/len(traces))
    axes.plot(iterations, regression_loss,
              color=c, ls=ls[i], lw=.75, label=names[i])

lines = []
labels = []

for ax in fig.axes:
    axLine, axLabel = ax.get_legend_handles_labels()
    lines.extend(axLine)
    labels.extend(axLabel)

fig.legend(lines, labels,
           loc='upper right', bbox_to_anchor=(0.85, 0.85))

plt.xlabel('Epochs')
plt.ylabel('Regression Loss')
plt.title('Regression Loss performance development by Steps')

figure_name = "all_regression_loss_{}_steps.png".format(str(steps))
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as ' + figure_name)

fig = plt.figure()
axes = fig.add_subplot(111)
for i, classification_loss in enumerate(classification_losses):
    c = cmap(float(i)/len(traces))
    axes.plot(iterations, classification_loss,
              color=c, ls=ls[i], lw=.75, label=names[i])

lines = []
labels = []

for ax in fig.axes:
    axLine, axLabel = ax.get_legend_handles_labels()
    lines.extend(axLine)
    labels.extend(axLabel)

fig.legend(lines, labels,
           loc='upper right', bbox_to_anchor=(0.85, 0.85))

plt.xlabel('Epochs')
plt.ylabel('Classification Loss')
plt.title('Classifitacion Loss performance development by Steps')

figure_name = "all_classifitacion_loss_{}_steps.png".format(str(steps))
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as ' + figure_name)
