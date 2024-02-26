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


find . -type f -name "./Compiled/*.vspv" | \
    for file in ./Compiled/*.vspv; do ./bintoc ${file} `basename ${file%.*}`_vert_spv ${file%.*}_vert.c; done

find . -type f -name "./Compiled/*.fspv" | \
    for file in ./Compiled/*.fspv; do ./bintoc ${file} `basename ${file%.*}`_frag_spv ${file%.*}_frag.c; done

find . -type f -name "./Compiled/*.cspv" | \
    for file in ./Compiled/*.cspv; do ./bintoc ${file} `basename ${file%.*}`_comp_spv ${file%.*}_comp.c; done
