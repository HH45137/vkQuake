#!/bin/bash

VULKAN_SDK=~/VulkanSDK/1.3.268.1/macOS/

if [[ ! -x "./bintoc" ]]
then
    gcc bintoc.c -o bintoc
fi


mkdir ./Compiled

find . -type f -name "*.vert" | \
    for file in *.vert ; do $VULKAN_SDK/bin/glslangValidator -V ${file} -o "./Compiled/${file%.*}.vspv"; done

find . -type f -name "*.frag" | \
    for file in *.frag ; do $VULKAN_SDK/bin/glslangValidator -V ${file} -o "./Compiled/${file%.*}.fspv"; done
