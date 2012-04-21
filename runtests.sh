#!/bin/sh

for i in tests/*.sh; do
        echo "I: Running $i ...";
        $i
        echo
done
