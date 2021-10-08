load(":defs.bzl", "myrule")

myrule(name = "treeA")

myrule(name = "treeB", with_file=True)

genrule(
    name = "check_treeA",
    srcs = [":treeA"],
    outs = ["checked"],
    cmd = "find -L .; [ -d $</empty ] && touch $@",
)

genrule(
    name = "check_treeB",
    srcs = [":treeB"],
    outs = ["checked2"],
    cmd = "find -L .; [ -d $</empty ] && touch $@",
)

genrule(
    name = "check_treeA_and_treeB",
    srcs = [":treeA", ":treeB"],
    outs = ["checked3"],
    cmd = "find -L .; [[ -d $(location :treeA)/empty && -d $(location :treeB)/empty ]] && touch $@",
)
