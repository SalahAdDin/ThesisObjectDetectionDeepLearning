import argparse
import os
import sys
import matplotlib
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--path", help="Log folder path")  # log file path
parser.add_argument("-n", "--number", type=int,
                    help="Number of iterations to plot")
args = parser.parse_args()

path = args.path
number = args.number

file_names = os.listdir(path)
names = [x.split('_')[-1].replace('.log', '') for x in file_names]
traces = [path+'/{}'.format(x) for x in file_names]
print(names)

fig = plt.figure()
axes = fig.add_subplot(111)
cmap = matplotlib.cm.get_cmap('Dark2')
ls = [(0, (3, 1, 1, 1, 1, 1)), '--', '-.', ':', (0, (3, 5, 1, 5, 1, 5)), ]

for j, trace in enumerate(traces):
    print(trace)

    c = cmap(float(j)/len(traces))

    lines = []
    for line in open(trace):
        if "avg" in line:
            lines.append(line)

    iterations = []
    avg_loss = []
    batches = number if number else len(lines)

    print('Retrieving data and plotting training loss graph...')
    for i in range(batches):
        lineParts = lines[i].split(',')
        iterations.append(int(lineParts[0].split(':')[0]))
        avg_loss.append(float(lineParts[1].split()[0]))

    axes.plot(iterations, avg_loss,
              color=c, ls=ls[j], lw=.75, label=names[j])

lines = []
labels = []

for ax in fig.axes:
    axLine, axLabel = ax.get_legend_handles_labels()
    lines.extend(axLine)
    labels.extend(axLabel)

fig.legend(lines, labels,
           loc='upper right', bbox_to_anchor=(0.85, 0.85))

plt.xlabel('Batch Number')
plt.ylabel('Avg Loss')

figure_name = "all_{}_plot.png".format(str(batches))
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as {}'.format(figure_name))
