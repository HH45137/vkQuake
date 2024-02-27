#!/bin/bash

VULKAN_SDK=~/VulkanSDK/1.3.268.1/macOS/

SCRIPT_DIR=$(dirname "$0") 
cd $SCRIPT_DIR/Shaders/

if [[ ! -x "./bintoc" ]]
then
    gcc bintoc.c -o bintoc
fi


for file in *.vert; do $VULKAN_SDK/bin/glslangValidator -V ${file} -o "./Compiled/${file%.*}.vspv"; done

for file in *.frag; do $VULKAN_SDK/bin/glslangValidator -V ${file} -o "./Compiled/${file%.*}.fspv"; done

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


for file in ./Compiled/*.vspv; do ./bintoc ${file} `basename ${file%.*}`_vert_spv ${file%.*}_vert.c; done

for file in ./Compiled/*.fspv; do ./bintoc ${file} `basename ${file%.*}`_frag_spv ${file%.*}_frag.c; done

for file in ./Compiled/*.cspv; do ./bintoc ${file} `basename ${file%.*}`_comp_spv ${file%.*}_comp.c; done


cd ..