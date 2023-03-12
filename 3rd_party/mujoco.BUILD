cc_library(
	name = "mujoco",
	# Get the version macro
	srcs = glob(["mujoco-2.3.2/lib/*.so*"]),
	hdrs = glob(["mujoco-2.3.2/include/mujoco/*"]),
	includes = ["mujoco-2.3.2/include"],
	visibility = ["//visibility:public"],
	linkstatic = 1,
)
