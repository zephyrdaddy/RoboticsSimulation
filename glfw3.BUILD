cc_library(
	name = "glfw3",
	# Get the version macro
	srcs = glob(["lib/x86_64-linux-gnu/libglfw.so*"]),
	hdrs = glob(["include/GLFW/*"]),
	includes = ["include"],
	visibility = ["//visibility:public"],
	linkstatic = 1,
)

#, "lib/x86_64-linux-gnu/libEGL.so", "lib/x86_64-linux-gnu/libGL.so", "lib/x86_64-linux-gnu/libGLEW.so*"