cmake_minimum_required(VERSION 3.5)

set(prjname "vkquake")
project(${prjname})

option(use_codec_wave "Use codec wave")
option(use_codec_mp3 "Use codec mp3")
set(mp3_lib "mad" CACHE STRING "Use mp3 lib")
option(use_codec_vorbis "Use codec vorbis")
set(vorbis_lib "vorbis" CACHE STRING "Use vorbis lib")

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

add_executable(${prjname} ${srcs})

target_compile_definitions(${prjname}
    PRIVATE "-Wall"
    PRIVATE "-Wno-trigraphs"
    PRIVATE "-Wno-unused-function"
    PRIVATE "-Werror"
)

if(CMAKE_HOST_APPLE)
    message("Current maching is Apple")

    find_library(sdl2 "sdl2" REQUIRED)
    find_library(m "m" REQUIRED)
    find_library(dl "dl" REQUIRED)

    find_library(moltenvk "MoltenVK")

    if(use_codec_wave)
        message("Add flag: -DUSE_CODEC_WAVE")
        target_compile_definitions(${prjname} PRIVATE "-DUSE_CODEC_WAVE")
    endif()

    if(mp3_lib STREQUAL "mad")
        find_library(mad "mad" use_codec_mp3)
        if(mad)
            message("Append library: mad")
            set(srcs ${srcs} "Quake/snd_mp3.c" "Quake/snd_mp3tag.c")
            message("Add flag: -DUSE_CODEC_MP3")
            target_compile_definitions(${prjname} PRIVATE "-DUSE_CODEC_MP3")
        endif()
    else()
        find_library(mpg123 "mpg123" use_codec_mp3)
        if(mpg123)
            message("Append library: mpg123")
            set(srcs ${srcs} "Quake/snd_mpg123.c" "Quake/snd_mp3tag.c")
            message("Add flag: -DUSE_CODEC_MP3")
            target_compile_definitions(${prjname} PRIVATE "-DUSE_CODEC_MP3")
        endif()
    endif()

    find_library(flac "flac")
    if(flac)
        message("Append library: flac")
        set(srcs ${srcs} "Quake/snd_flac.c")
    endif()

    find_library(ogg "ogg" use_codec_vorbis)
    if(vorbis_lib STREQUAL "vorbis")
        find_library(vorbisfile "vorbisfile" use_codec_vorbis)
        find_library(vorbis "vorbis" use_codec_vorbis)
        if(ogg AND vorbisfile AND vorbis)
            set(srcs ${srcs} "Quake/snd_vorbis.c")
            message("Add flag: -DUSE_CODEC_VORBIS")
            target_compile_definitions(${prjname} PRIVATE "-DUSE_CODEC_VORBIS")
        endif()
    else()
        find_library(vorbisidec "vorbisidec" use_codec_vorbis)
        if(ogg AND vorbisidec)
            set(srcs ${srcs} "Quake/snd_vorbis.c")
            message("Add flag: -DUSE_CODEC_VORBIS -DVORBIS_USE_TREMOR")
            target_compile_definitions(${prjname} PRIVATE "-DUSE_CODEC_VORBIS" "-DVORBIS_USE_TREMOR")
        endif()
    endif()
    

endif()