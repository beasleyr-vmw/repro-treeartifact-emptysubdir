def _myrule_impl(ctx):
    outdir = ctx.actions.declare_directory(ctx.label.name)
    args = ctx.actions.args()
    args.add(outdir.path)
    args.add(str(ctx.attr.with_file).lower())  # True -> "true"
    ctx.actions.run_shell(
        command = "outdir=$1; mkdir -p $outdir/empty; $2 && touch $outdir/dummyfile || true",
        outputs = [outdir],
	arguments = [args],
    )
    return DefaultInfo(files = depset([outdir]), runfiles = ctx.runfiles([outdir]))

myrule = rule(implementation = _myrule_impl, attrs = {"with_file": attr.bool()})
