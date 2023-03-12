#include <iostream>

#include "cstdio"
#include "cstdlib"
#include "cstring"
#include "GLFW/glfw3.h"

// Libraries for sleep
#include <chrono>
#include <thread>

// mouse interaction
bool button_left = false;
bool button_middle = false;
bool button_right =  false;
double lastx = 0;
double lasty = 0;

// controller related variables
// float_t ctrl_update_freq = 100;


// keyboard callback
void keyboard(GLFWwindow* window, int key, int scancode, int act, int mods)
{
    // backspace: reset simulation
    if( act==GLFW_PRESS && key==GLFW_KEY_BACKSPACE )
    {

    }
}


// mouse button callback
void mouse_button(GLFWwindow* window, int button, int act, int mods)
{
    // update button state
    button_left =   (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT)==GLFW_PRESS);
    button_middle = (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_MIDDLE)==GLFW_PRESS);
    button_right =  (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_RIGHT)==GLFW_PRESS);

    // update mouse position
    glfwGetCursorPos(window, &lastx, &lasty);
}


// mouse move callback
void mouse_move(GLFWwindow* window, double xpos, double ypos)
{
    // no buttons down: nothing to do
    if( !button_left && !button_middle && !button_right )
        return;

    // compute mouse displacement, save
    double dx = xpos - lastx;
    double dy = ypos - lasty;
    lastx = xpos;
    lasty = ypos;

    // get current window size
    int width, height;
    glfwGetWindowSize(window, &width, &height);

    // get shift key state
    bool mod_shift = (glfwGetKey(window, GLFW_KEY_LEFT_SHIFT)==GLFW_PRESS ||
                      glfwGetKey(window, GLFW_KEY_RIGHT_SHIFT)==GLFW_PRESS);

    // determine action based on mouse button
    // mjtMouse action;
    // if( button_right )
    //     action = mod_shift ? mjMOUSE_MOVE_H : mjMOUSE_MOVE_V;
    // else if( button_left )
    //     action = mod_shift ? mjMOUSE_ROTATE_H : mjMOUSE_ROTATE_V;
    // else
    //     action = mjMOUSE_ZOOM;

    // // move camera
    // mjv_moveCamera(m, action, dx/height, dy/height, &scn, &cam);
}


// scroll callback
void scroll(GLFWwindow* window, double xoffset, double yoffset)
{
    // emulate vertical mouse motion = 5% of window height
    // mjv_moveCamera(m, mjMOUSE_ZOOM, 0, -0.05*yoffset, &scn, &cam);
}

// // control loop callback
// void mycontroller(const mjModel* m, mjData* d)
// {
//     // printouts for debugging purposes
//     std::cout << "number of position coordinates: " << m->nq << std::endl;
//     std::cout << "number of degrees of freedom: " << m->nv << std::endl;
//     std::cout << "joint position: " << d->qpos[0] << std::endl;
//     std::cout << "joint velocity: " << d->qvel[0] << std::endl;
//     std::cout << "Sensor output: " << d->sensordata[0] << std::endl;

//     // controller with true values, but it is cheating.
// //    ctrl = 3.5*(-d->qvel[0]-10.0*d->qpos[0]);

//     // controller with sensor readings
//     if (previous_time == 0)
//     {
//         previous_time = d->time;
//         return;
//     }
//     if (d->time - last_update > 1.0/ctrl_update_freq)
//     {
//         mjtNum vel = (d->sensordata[0] - position_history)/(d->time-previous_time);
//         ctrl = 3.5*(-vel-10.0*d->sensordata[0]);
//         last_update = d->time;
//         position_history = d->sensordata[0];
//         previous_time = d->time;
//     }
//     d->ctrl[0] = ctrl;

//     std::cout << "torque effort: " << ctrl << std::endl;
// }


// main function
int main(int argc, const char** argv)
{

    // activate software
    // mj_activate("../license/mjkey.txt");
    // mj_activate("/usr/master-robotics/license/mjkey.txt");


    // // load and compile model
    // char error[1000] = "Could not load binary model";

    // // check command-line arguments
    // if( argc<2 )
    //     // m = mj_loadXML("../models/invertedPendulum.xml", 0, error, 1000);
    //     m = mj_loadXML("/usr/master-robotics/models/invertedPendulum.xml", 0, error, 1000);

    // else
    //     if( strlen(argv[1])>4 && !strcmp(argv[1]+strlen(argv[1])-4, ".mjb") )
    //         m = mj_loadModel(argv[1], 0);
    //     else
    //         m = mj_loadXML(argv[1], 0, error, 1000);
    // if( !m )
    //     mju_error_s("Load model error: %s", error);

    // // make data
    // d = mj_makeData(m);

glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
    // init GLFW
    if( !glfwInit() )
        return -1;
        // mju_error("Could not initialize GLFW");

    // create window, make OpenGL context current, request v-sync
    GLFWwindow* window = glfwCreateWindow(1244, 700, "Demo", NULL, NULL);
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1);
    if (window == NULL) printf("Null window\n");
    // initialize visualization data structures
    // mjv_defaultCamera(&cam);
    // mjv_defaultOption(&opt);
    // mjv_defaultScene(&scn);
    // mjr_defaultContext(&con);
    // mjv_makeScene(m, &scn, 2000);                // space for 2000 objects
    // mjr_makeContext(m, &con, mjFONTSCALE_150);   // model-specific context

    // install GLFW mouse and keyboard callbacks
    glfwSetKeyCallback(window, keyboard);
    glfwSetCursorPosCallback(window, mouse_move);
    glfwSetMouseButtonCallback(window, mouse_button);
    glfwSetScrollCallback(window, scroll);

    // install control callback
    // mjcb_control = mycontroller;

    // // initial position
    // d->qpos[0] = 1.57;

    // // run main loop, target real-time simulation and 60 fps rendering
    // mjtNum timezero = d->time;
    // double_t update_rate = 0.01;

    // // making sure the first time step updates the ctrl previous_time
    // last_update = timezero-1.0/ctrl_update_freq;

    // use the first while condition if you want to simulate for a period.
//    while( !glfwWindowShouldClose(window) and d->time-timezero < 1.5)
    while( !glfwWindowShouldClose(window))
    {
        // advance interactive simulation for 1/60 sec
        //  Assuming MuJoCo can simulate faster than real-time, which it usually can,
        //  this loop will finish on time for the next frame to be rendered at 60 fps.
        //  Otherwise add a cpu timer and exit this loop when it is time to render.
    //     mjtNum simstart = d->time;
    //     while( d->time - simstart < 1.0/60.0 )
    //         mj_step(m, d);

    //     // 15 ms is a little smaller than 60 Hz.
        std::this_thread::sleep_for(std::chrono::milliseconds(15));
    //    // get framebuffer viewport
    //     mjrRect viewport = {0, 0, 0, 0};
        // glfwGetFramebufferSize(window, &viewport.width, &viewport.height);

          // update scene and render
        // mjv_updateScene(m, d, &opt, NULL, &cam, mjCAT_ALL, &scn);
        // mjr_render(viewport, &scn, &con);

        // swap OpenGL buffers (blocking call due to v-sync)
        glfwSwapBuffers(window);

        // process pending GUI events, call GLFW callbacks
        glfwPollEvents();

    }

    // free visualization storage
    // mjv_freeScene(&scn);
    // mjr_freeContext(&con);

    // free MuJoCo model and data, deactivate
    // mj_deleteData(d);
    // mj_deleteModel(m);
    // mj_deactivate();

    // terminate GLFW (crashes with Linux NVidia drivers)
    #if defined(__APPLE__) || defined(_WIN32)
        glfwTerminate();
    #endif

    return 1;
}