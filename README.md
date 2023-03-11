# Mujoco Simulation Study Project
# How to Set Up the Environment
1. Install the docker environment
docker build -f Dockerfile --tag=study-robotics .

2. To access the GUI, run the following command
xhost + 

3. Run the docker image 
docker run -d -it --ipc=host --net=host --privileged -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  --name dev_vslam_frontend -v ${Project_Path}:/usr/master-robotics/ -v ${Dataset_Path}:/usr/src/data study-robotics:latest


4. Build the code
bazel build --copt=-fdiagnostics-color=always //...

5. Run the code with a sample dataset
bazel run //src:${Program_name} /usr/src/data/