#!/bin/bash

VULKAN_SDK=~/VulkanSDK/1.3.268.1/macOS/

if [[ ! -x "./bintoc" ]]
then
    gcc bintoc.c -o bintoc
fi


find . -type f -name "*.vert" | \
    for file in *.vert; do $VULKAN_SDK/bin/glslangValidator -V ${file} -o "./Compiled/${file%.*}.vspv"; done

find . -type f -name "*.frag" | \
    for file in *.frag; do $VULKAN_SDK/bin/glslangValidator -V ${file} -o "./Compiled/${file%.*}.fspv"; done

find . -type f -name "*.comp" | \
    for file in *.comp; 
    do
        filename=${file}
        substring="sops"    
        if test "${filename#*$substring}" != "$filename"; then
            $VULKAN_SDK/bin/glslangValidator -V ${file} --target-env vulkan1.3 -o "./Compiled/${file%.*}.cspv"; 
        else
            $VULKAN_SDK/bin/glslangValidator -V ${file} -o "./Compiled/${file%.*}.cspv"; 
        fi
    done


