#!/bin/bash

set -euo pipefail

cleanup() {
    for worktree in "${worktrees[@]}"
    do
	git worktree remove "$worktree"
    done
}

trap cleanup EXIT

declare -a \
	worktrees \
	branches

branches=(
    dacoda/issue/104/master
    dacoda/issue/104/test-on-origin-master
)

declare projectRoot=$PWD

declare -gx CL_SOURCE_REGISTRY

declare branch
for branch in "${branches[@]}"
do
    declare \
	branchSlug \
	worktree \
	results

    branchSlug=${branch//\//-}
    worktree=worktree/test/$branchSlug
    results=$projectRoot/var/lib/test/$environment/$branchSlug

    mkdir -p "$results"
    git worktree add -f "$worktree" "$branch"
    worktrees+=( "$worktree" )

    pushd "$worktree"

    CL_SOURCE_REGISTRY=$projectRoot/$worktree

    {
	 sbcl --load $projectRoot/harness alpha

	for (( i = 0 ; i < 2 ; ++i ))
	do
	    sbcl --load $projectRoot/harness beta
	done
    } |& tee "$results"/results.txt

    popd
done
