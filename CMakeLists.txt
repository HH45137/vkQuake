cmake_minimum_required(VERSION 3.5)

set(prjname "vkquake")
project(${prjname})

if(CMAKE_HOST_WIN32)
    message("Build in windows.")    

    # ------------------ Shaders Compile ------------------
    message("Start compile shaders form bin to c files")
    execute_process (COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/windows_shaders_compile.bat)
    file(GLOB shader_srcs "./Shaders/Compiled/*.c")

endif()


if(CMAKE_HOST_APPLE)
    message("Build in MacOS.")            

    # ------------------ Shaders Compile ------------------
    message("Start compile shaders form bin to c files")
    execute_process (COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/macos_shaders_compile.sh)
    file(GLOB shader_srcs "./Shaders/Compiled/*.c")

    # ------------------ C Codes ------------------

    option(use_codec_wave "Use codec wave")
    option(use_codec_mp3 "Use codec mp3")
    set(mp3_lib "mad" CACHE STRING "Use mp3 lib")
    option(use_codec_vorbis "Use codec vorbis")
    set(vorbis_lib "vorbis" CACHE STRING "Use vorbis lib")
    option(use_codec_opus "Use codec opus")

    file(GLOB headers "./Quake/*.h")
    set(srcs
        "Quake/bgmusic.c"
        "Quake/cd_null.c"
        "Quake/cfgfile.c"
        "Quake/chase.c"
        "Quake/cl_demo.c"
        "Quake/cl_input.c"
        "Quake/cl_main.c"
        "Quake/cl_parse.c"
        "Quake/cl_tent.c"
        "Quake/cmd.c"
        "Quake/common.c"
        "Quake/console.c"
        "Quake/crc.c"
        "Quake/cvar.c"
        "Quake/gl_draw.c"
        "Quake/gl_fog.c"
        "Quake/gl_heap.c"
        "Quake/gl_mesh.c"
        "Quake/gl_model.c"
        "Quake/gl_refrag.c"
        "Quake/gl_rlight.c"
        "Quake/gl_rmain.c"
        "Quake/gl_rmisc.c"
        "Quake/gl_screen.c"
        "Quake/gl_sky.c"
        "Quake/gl_texmgr.c"
        "Quake/gl_vidsdl.c"
        "Quake/gl_warp.c"
        "Quake/host.c"
        "Quake/host_cmd.c"
        "Quake/image.c"
        "Quake/in_sdl.c"
        "Quake/keys.c"
        "Quake/main_sdl.c"
        "Quake/mathlib.c"
        "Quake/mdfour.c"
        "Quake/mem.c"
        "Quake/menu.c"
        "Quake/miniz.c"
        "Quake/net_bsd.c"
        "Quake/net_dgrm.c"
        "Quake/net_loop.c"
        "Quake/net_main.c"
        "Quake/net_udp.c"
        "Quake/palette.c"
        "Quake/pl_linux.c"
        "Quake/pr_cmds.c"
        "Quake/pr_edict.c"
        "Quake/pr_exec.c"
        "Quake/pr_ext.c"
        "Quake/r_alias.c"
        "Quake/r_brush.c"
        "Quake/r_part.c"
        "Quake/r_part_fte.c"
        "Quake/r_sprite.c"
        "Quake/r_world.c"
        "Quake/sbar.c"
        "Quake/snd_codec.c"
        "Quake/snd_dma.c"
        "Quake/snd_mem.c"
        "Quake/snd_mix.c"
        "Quake/snd_sdl.c"
        "Quake/snd_umx.c"
        "Quake/snd_wave.c"
        "Quake/strlcat.c"
        "Quake/strlcpy.c"
        "Quake/sv_main.c"
        "Quake/sv_move.c"
        "Quake/sv_phys.c"
        "Quake/sv_user.c"
        "Quake/sys_sdl.c"
        "Quake/sys_sdl_unix.c"
        "Quake/tasks.c"
        "Quake/view.c"
        "Quake/wad.c"
        "Quake/world.c"
        "Quake/hash_map.c"
        "Quake/embedded_pak.c"
    )

    find_library(m_dep "m" REQUIRED)
    find_library(dl_dep "dl" REQUIRED)

    find_package(SDL2 REQUIRED)
    find_library(SDL2_LIBRARY "sdl2")

    find_package(Vulkan)
    find_library(moltenvk_dep "moltenvk")

    # ---------- mp3 ----------
    if(${mp3_lib} STREQUAL "mad")
        message("Include mad header files")    
        set(srcs ${srcs} "Quake/snd_mp3.c" "Quake/snd_mp3tag.c")
    else()
        message("Include mpg123 header files")    
        set(srcs ${srcs} "Quake/snd_mpg123.c" "Quake/snd_mp3tag.c")
    endif()


    source_group("Shaders" ${CMAKE_SOURCE_DIR} FILES ${shader_srcs})
    add_executable(${prjname} ${srcs} ${headers} ${shader_srcs})


    target_compile_definitions(${prjname}
        PRIVATE "Wall"
        PRIVATE "Wno-trigraphs"
        PRIVATE "Wno-unused-function"
        PRIVATE "Werror"
    )

    # ---------- Other ----------
    target_link_libraries(${prjname} ${m_dep})
    target_link_libraries(${prjname} ${dl_dep})

    # ---------- SDL2 ----------
    if(SDL2_FOUND)
        message("Add SDL2")
        include_directories(${prjname} ${SDL2_INCLUDE_DIR})
        target_link_libraries(${prjname} ${SDL2_LIBRARY})
    endif()

    # ---------- Vulkan ----------
    if(Vulkan_FOUND)
        message("Add Vulkan")
        include_directories(${prjname} ${Vulkan_INCLUDE_DIRS})
        # target_link_libraries(${prjname} ${Vulkan_LIBRARY})
        target_link_libraries(${prjname} ${moltenvk_dep})
    endif()

    # ---------- use_codec_wave ----------
    if(use_codec_wave)
        message("Add flag: USE_CODEC_WAVE")
        target_compile_definitions(${prjname} PRIVATE "USE_CODEC_WAVE")
    endif()

    # ---------- mp3 ----------
    if(${mp3_lib} STREQUAL "mad")
        message("Use mad library")
        
        find_library(mad_dep "mad")
        target_link_libraries(${prjname} ${mad_dep})
        
        message("Add flag: USE_CODEC_MP3")
        target_compile_definitions(${prjname} PRIVATE "USE_CODEC_MP3")
    else()
        message("Use mpg123 library")    

    endif()

endif()
