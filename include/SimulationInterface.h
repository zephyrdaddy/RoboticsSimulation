#pragma once

#include <mujoco/mujoco.h>
#include <memory>


class SimulationInterface {


private:
  std::shared_ptr<mjModel> mujoco_model_;
  std::shared_ptr<mjData> mujoco_data_;


};