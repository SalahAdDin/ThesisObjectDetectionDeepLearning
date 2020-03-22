# Thesis: Object Detection with Deep Learning
The following is a repository containing all scripts used in the development of the thesis. It contains both the scripts necessary to execute the projects and the scripts executed in the processing of the datasets and in the analysis of the results.

## Setup

We need to create a *project* folder and we clone this repository inside of:

```sh
mkdir Projects/
git clone https://github.com/SalahAdDin/ThesisObjectDetectionDeepLearning thesis
```

After, we will run the setup file:

```shell
cd thesis && ./setup.sh
```

We must ensure all **shell** scripts have execution permissions.

Also we can test if the setup was successful or not.

## Experiments

We are testing three different frameworks, for each one we have one script:

```shell
./retinanet.sh
./yolov3.sh
./maskrcnn.sh
```

**RetinaNet** is the easier from these frameworks; based on our experience, training in this framework takes less than four hours and logs are easy to get and handle, that's why we suggest to test this experiment first.

**YOLOv3** takes more time than **RetinaNet**, but it requires a different setup before to train the model, that's why we put it in the second step.

**Mask-RCNN** is a different thing, we didn't get a full trained model yet, therefore, we also couldn't get a full training and evaluating log; in these conditions, we will train it at last and we will handle possible problems after to finish the other experiments.

## Analysis

We have structure experiments in order to get the main measure that we chose for comparing the datasets:

- mAP
- F1 score
- Training Time
- Inference Time

For getting the *training time* we record the execution outputs for each framework(which include start and finish training time); for the other three measure, each framework includes an implementation to get this measure, making it easier to record for comparison purposes.

We also have two script for plotting results from training logs: one for **YOLO** and one for **TensorFlow** based implementations. 



Do we miss something? Please write us a new issue explaining all you need to say. Thanks!