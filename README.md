# Mujoco Simulation Study Project
# How to Set Up the Environment
1. Install the docker environment
docker build -f Dockerfile --tag=study-robotics -build-arg IMAGE_NAME=base .

2. To access the GUI, run the following command
xhost + 

3. Follow this link to set up the CUDA in your machine
   https://www.howtogeek.com/devops/how-to-use-an-nvidia-gpu-with-docker-containers/

4. Run the docker image 
docker run -d -it --ipc=host --net=host --privileged -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  --name dev_robotics -v {Project_Path}:/usr/master-robotics/ -v {Dataset_Path}:/usr/src/data study-robotics:latest

ex)
docker run -d -it --gpus all --ipc=host --net=host --privileged -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  --name dev_robotics -v /home/{USER_NAME}/Projects/MujocoSimulation/:/usr/master-robotics study-robotics:latest 


4. Build the code
bazel build --copt=-fdiagnostics-color=always //...

5. Run the code with a sample dataset
bazel run //src:{Program_name} /usr/src/data/