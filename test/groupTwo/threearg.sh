#!/bin/bash
X="$(./dist/build/BackflipDemo/BackflipDemo alpha beta gamma)"
if [ "$X" != "$(echo -e "gamma\nbeta\nalpha")" ]; then
    exit 1
fi
