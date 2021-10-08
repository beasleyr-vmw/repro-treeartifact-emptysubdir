# Repro demonstrating elision of empty directories from tree artifacts

Consider two tree artifacts, `treeA` and `treeB`.  Both contain an empty
directory named `empty`, but `treeB` also contains a file named `dummy`.

```console
$ tree tree*
treeA
└── empty
treeB
├── dummy
└── empty
```

When these tree artifacts are provided as inputs to a sandboxed action,
Bazel elides the empty directory from `treeB`.  (If, however, a tree
artifact's only content is an empty directory, then the empty directory
appears in the action's sandbox.)

```console
$ bazel build -j 1 -k :all
INFO: Analyzed 5 targets (1 packages loaded, 5 targets configured).
INFO: Found 5 targets...
INFO: From Executing genrule //:check_treeA:
.
./external
./external/bazel_tools
./external/bazel_tools/tools
./external/bazel_tools/tools/genrule
./external/bazel_tools/tools/genrule/genrule-setup.sh
./bazel-out
./bazel-out/k8-fastbuild
./bazel-out/k8-fastbuild/bin
./bazel-out/k8-fastbuild/bin/treeA
./bazel-out/k8-fastbuild/bin/treeA/empty
ERROR: $PWD/BUILD:14:8: Executing genrule //:check_treeB failed: (Exit 1): bash failed: error executing command /bin/bash -c 'source external/bazel_tools/tools/genrule/genrule-setup.sh; find -L .; [ -d bazel-out/k8-fastbuild/bin/treeB/empty ] && touch bazel-out/k8-fastbuild/bin/checked2'

Use --sandbox_debug to see verbose messages from the sandbox
.
./external
./external/bazel_tools
./external/bazel_tools/tools
./external/bazel_tools/tools/genrule
./external/bazel_tools/tools/genrule/genrule-setup.sh
./bazel-out
./bazel-out/k8-fastbuild
./bazel-out/k8-fastbuild/bin
./bazel-out/k8-fastbuild/bin/treeB
./bazel-out/k8-fastbuild/bin/treeB/dummyfile
ERROR: $PWD/BUILD:21:8: Executing genrule //:check_treeA_and_treeB failed: (Exit 1): bash failed: error executing command /bin/bash -c ... (remaining 1 argument(s) skipped)

Use --sandbox_debug to see verbose messages from the sandbox
.
./external
./external/bazel_tools
./external/bazel_tools/tools
./external/bazel_tools/tools/genrule
./external/bazel_tools/tools/genrule/genrule-setup.sh
./bazel-out
./bazel-out/k8-fastbuild
./bazel-out/k8-fastbuild/bin
./bazel-out/k8-fastbuild/bin/treeA
./bazel-out/k8-fastbuild/bin/treeA/empty
./bazel-out/k8-fastbuild/bin/treeB
./bazel-out/k8-fastbuild/bin/treeB/dummyfile
INFO: Elapsed time: 0.671s, Critical Path: 0.07s
INFO: 6 processes: 3 internal, 3 linux-sandbox.
FAILED: Build did NOT complete successfully
```
