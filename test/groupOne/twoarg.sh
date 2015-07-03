#!/bin/bash
X="$(./dist/build/BackflipDemo/BackflipDemo test goo)"
if [ "$X" != "$(echo -e "goo\ntest")" ]; then
    exit 1
fi
