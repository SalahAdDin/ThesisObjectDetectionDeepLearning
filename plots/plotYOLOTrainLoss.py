import argparse
import sys
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--path", help="Log file path")  # log file path
args = parser.parse_args()

path = args.path

lines = []
for line in open(path):
    if "avg" in line:
        lines.append(line)

iterations = []
avg_loss = []

print('Retrieving data and plotting training loss graph...')
for i in range(len(lines)):
    lineParts = lines[i].split(',')
    iterations.append(int(lineParts[0].split(':')[0]))
    avg_loss.append(float(lineParts[1].split()[0]))

fig = plt.figure()
for i in range(0, len(lines)):
    plt.plot(iterations[i:i+2], avg_loss[i:i+2], 'r.-')

plt.xlabel('Batch Number')
plt.ylabel('Avg Loss')

figure_name = path.replace(".log", "_plot.png")
fig.savefig(figure_name, dpi=1000)

print('Done! Plot saved as training_loss_plot.png')
