load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "mujoco",
    url = "https://github.com/deepmind/mujoco/releases/download/2.3.2/mujoco-2.3.2-linux-x86_64.tar.gz",
    sha256 = "cad8bf31cb06cfb590f80537c4adf3d32102a588bb1202774bc0efa1493f530d",
    build_file = "@//:3rd_party/mujoco.BUILD",
)

new_local_repository(
    name = "rbdl",
    build_file = "3rd_party/rbdl.BUILD",
    path = "/usr/local",
)

new_local_repository(
    name = "osqp",
    build_file = "3rd_party/osqp.BUILD",
    path = "/usr/local",
)

new_local_repository(
    name = "qpoases",
    build_file = "3rd_party/qpoases.BUILD",
    path = "/usr/local",
)

new_local_repository(
    name = "glfw3",
    build_file = "3rd_party/glfw3.BUILD",
    path = "/usr",
)
