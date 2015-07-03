#!/bin/sh
X="$(./dist/build/BackflipDemo/BackflipDemo test)"
if [ "$X" != "test" ]; then
    exit 1
fi
