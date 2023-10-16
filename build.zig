const std = @import("std");

pub fn defineOsMacros(step: *std.Build.Step.Compile) void {
    const target = step.target_info.target;
    switch (target.os.tag) {
        .linux => step.defineCMacro("__LINUX__", null),
        .macos => step.defineCMacro("__MACOSX__", null),
        .windows => step.defineCMacro("__WIN32__", null),
        else => if (target.os.tag.isBSD()) {
            step.defineCMacro("__BSD__", null);
        } else {
            std.log.err("Unsupported OS: {}", .{target});
            step.step.owner.invalid_user_input = true;
        },
    }
    if (target.isMinGW()) step.defineCMacro("__MINGW32__", null);
}

pub fn build(b: *std.Build) void {
    const upstream = b.dependency("tilibs", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libticonv = b.addStaticLibrary(.{
        .name = "ticonv",
        .target = target,
        .optimize = optimize,
    });
    libticonv.linkLibCpp();
    libticonv.linkSystemLibrary("glib-2.0");
    libticonv.defineCMacro("restrict", "__restrict");
    libticonv.defineCMacro("TICONV_EXPORTS", "");
    libticonv.defineCMacro("VERSION", "\"1.1.6\"");
    defineOsMacros(libticonv);
    libticonv.addCSourceFiles(.{
        .dependency = upstream,
        .files = &.{
            "libticonv/trunk/src/charset.cc",
            "libticonv/trunk/src/filename.cc",
            "libticonv/trunk/src/iconv.c",
            "libticonv/trunk/src/ticonv.cc",
            "libticonv/trunk/src/tokens.cc",
            "libticonv/trunk/src/type2str.cc",
        },
    });
    libticonv.installHeadersDirectoryOptions(.{
        .source_dir = upstream.path("libticonv/trunk/src"),
        .install_dir = .header,
        .install_subdir = "",
        .include_extensions = &.{
            "charset.h",
            "export4.h",
            "ticonv.h",
        },
    });
    b.installArtifact(libticonv);

    const libtifiles2 = b.addStaticLibrary(.{
        .name = "tifiles2",
        .target = target,
        .optimize = optimize,
    });
    libtifiles2.linkLibCpp();
    libtifiles2.linkSystemLibrary("archive");
    libtifiles2.linkSystemLibrary("glib-2.0");
    libtifiles2.linkLibrary(libticonv);
    libtifiles2.defineCMacro("LOCALEDIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, "locale"),
    }));
    libtifiles2.defineCMacro("restrict", "__restrict");
    libtifiles2.defineCMacro("VERSION", "\"1.1.8\"");
    defineOsMacros(libtifiles2);
    libtifiles2.addCSourceFiles(.{
        .dependency = upstream,
        .files = &.{
            "libtifiles/trunk/src/cert.cc",
            "libtifiles/trunk/src/comments.cc",
            "libtifiles/trunk/src/error.cc",
            "libtifiles/trunk/src/files8x.cc",
            "libtifiles/trunk/src/files9x.cc",
            "libtifiles/trunk/src/filesnsp.cc",
            "libtifiles/trunk/src/filesxx.cc",
            "libtifiles/trunk/src/filetypes.cc",
            "libtifiles/trunk/src/grouped.cc",
            "libtifiles/trunk/src/intelhex.cc",
            "libtifiles/trunk/src/misc.cc",
            "libtifiles/trunk/src/rwfile.cc",
            "libtifiles/trunk/src/tifiles.cc",
            "libtifiles/trunk/src/tigroup.cc",
            "libtifiles/trunk/src/type2str.cc",
            "libtifiles/trunk/src/types68k.cc",
            "libtifiles/trunk/src/types83p.cc",
            "libtifiles/trunk/src/typesnsp.cc",
            "libtifiles/trunk/src/typesoldz80.cc",
            "libtifiles/trunk/src/typesxx.cc",
            "libtifiles/trunk/src/ve_fp.cc",
        },
        .flags = &.{},
    });
    libtifiles2.installHeadersDirectoryOptions(.{
        .source_dir = upstream.path("libtifiles/trunk/src"),
        .install_dir = .header,
        .install_subdir = "",
        .include_extensions = &.{
            "tifiles.h",
            "export2.h",
            "files8x.h",
            "files9x.h",
            "types73.h",
            "types82.h",
            "types83.h",
            "types83p.h",
            "types84p.h",
            "types85.h",
            "types86.h",
            "types89.h",
            "types89t.h",
            "types92.h",
            "types92p.h",
            "typesnsp.h",
            "typesv2.h",
            "typesxx.h",
        },
    });
    b.installArtifact(libtifiles2);

    const libticables2 = b.addStaticLibrary(.{
        .name = "ticables2",
        .target = target,
        .optimize = optimize,
    });
    libticables2.linkLibCpp();
    libticables2.linkSystemLibrary("glib-2.0");
    libticables2.linkSystemLibrary("libusb-1.0");
    libticables2.addIncludePath(
        upstream.path("libticables/trunk/src"),
    );
    libticables2.defineCMacro("HAVE_LIBUSB_1_0", "1");
    libticables2.defineCMacro("HAVE_LIBUSB10_STRERROR", "1");
    libticables2.defineCMacro("HAVE_TERMIOS_H", "1");
    libticables2.defineCMacro("LOCALEDIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, "locale"),
    }));
    libticables2.defineCMacro("VERSION", "\"1.3.6\"");
    defineOsMacros(libticables2);
    libticables2.addCSourceFiles(.{
        .dependency = upstream,
        .files = &.{
            "libticables/trunk/src/data_log.cc",
            "libticables/trunk/src/detect.cc",
            "libticables/trunk/src/error.cc",
            "libticables/trunk/src/hex2dbus.cc",
            "libticables/trunk/src/hex2dusb.cc",
            "libticables/trunk/src/hex2nsp.cc",
            "libticables/trunk/src/ioports.cc",
            "libticables/trunk/src/link_blk.cc",
            "libticables/trunk/src/link_gry.cc",
            "libticables/trunk/src/link_nul.cc",
            "libticables/trunk/src/link_par.cc",
            "libticables/trunk/src/link_tcpc.cc",
            "libticables/trunk/src/link_tcps.cc",
            "libticables/trunk/src/link_tie.cc",
            "libticables/trunk/src/link_usb.cc",
            "libticables/trunk/src/link_vti.cc",
            "libticables/trunk/src/link_xxx.cc",
            "libticables/trunk/src/log_dbus.cc",
            "libticables/trunk/src/log_dusb.cc",
            "libticables/trunk/src/log_hex.cc",
            "libticables/trunk/src/log_nsp.cc",
            "libticables/trunk/src/none.cc",
            "libticables/trunk/src/probe.cc",
            "libticables/trunk/src/ticables.cc",
            "libticables/trunk/src/type2str.cc",
        },
        .flags = &.{},
    });
    libticables2.installHeadersDirectoryOptions(.{
        .source_dir = upstream.path("libticables/trunk/src"),
        .install_dir = .header,
        .install_subdir = "",
        .include_extensions = &.{
            "ticables.h",
            "export1.h",
            "timeout.h",
        },
    });
    b.installArtifact(libticables2);

    const libticalcs2 = b.addStaticLibrary(.{
        .name = "ticalcs2",
        .target = target,
        .optimize = optimize,
    });
    libticalcs2.linkLibC();
    libticalcs2.linkLibrary(libticonv);
    libticalcs2.linkLibrary(libtifiles2);
    libticalcs2.linkLibrary(libticables2);
    libticalcs2.defineCMacro("HAVE_ASCTIME_R", "1");
    libticalcs2.defineCMacro("HAVE_CTIME_R", "1");
    libticalcs2.defineCMacro("HAVE_LOCALTIME_R", "1");
    libticalcs2.defineCMacro("LOCALEDIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, "locale"),
    }));
    libticalcs2.defineCMacro("restrict", "__restrict");
    libticalcs2.defineCMacro("VERSION", "\"1.1.10\"");
    defineOsMacros(libticalcs2);
    libticalcs2.addCSourceFiles(.{
        .dependency = upstream,
        .files = &.{
            "libticalcs/trunk/src/backup.cc",
            "libticalcs/trunk/src/calc_00.cc",
            "libticalcs/trunk/src/calc_73.cc",
            "libticalcs/trunk/src/calc_84p.cc",
            "libticalcs/trunk/src/calc_89t.cc",
            "libticalcs/trunk/src/calc_8x.cc",
            "libticalcs/trunk/src/calc_9x.cc",
            "libticalcs/trunk/src/calc_nsp.cc",
            "libticalcs/trunk/src/calc_xx.cc",
            "libticalcs/trunk/src/clock.cc",
            "libticalcs/trunk/src/cmd68k.cc",
            "libticalcs/trunk/src/cmdz80.cc",
            "libticalcs/trunk/src/dbus_pkt.cc",
            "libticalcs/trunk/src/dirlist.cc",
            "libticalcs/trunk/src/dusb_cmd.cc",
            "libticalcs/trunk/src/dusb_rpkt.cc",
            "libticalcs/trunk/src/dusb_vpkt.cc",
            "libticalcs/trunk/src/error.cc",
            "libticalcs/trunk/src/keys73.cc",
            "libticalcs/trunk/src/keys83.cc",
            "libticalcs/trunk/src/keys83p.cc",
            "libticalcs/trunk/src/keys86.cc",
            "libticalcs/trunk/src/keys89.cc",
            "libticalcs/trunk/src/keys92p.cc",
            "libticalcs/trunk/src/nsp_cmd.cc",
            "libticalcs/trunk/src/nsp_rpkt.cc",
            "libticalcs/trunk/src/nsp_vpkt.cc",
            "libticalcs/trunk/src/probe.cc",
            "libticalcs/trunk/src/romdump.cc",
            "libticalcs/trunk/src/screen.cc",
            "libticalcs/trunk/src/ticalcs.cc",
            "libticalcs/trunk/src/tikeys.cc",
            "libticalcs/trunk/src/type2str.cc",
            "libticalcs/trunk/src/update.cc",
        },
        .flags = &.{},
    });
    libticalcs2.installHeadersDirectoryOptions(.{
        .source_dir = upstream.path("libticalcs/trunk/src"),
        .install_dir = .header,
        .install_subdir = "",
        .include_extensions = &.{
            "ticalcs.h",
            "export3.h",
            "romdump.h",
            "keys73.h",
            "keys83.h",
            "keys83p.h",
            "keys86.h",
            "keys89.h",
            "keys92p.h",
            "dbus_pkt.h",
            "dusb_rpkt.h",
            "dusb_vpkt.h",
            "dusb_cmd.h",
            "nsp_rpkt.h",
            "nsp_vpkt.h",
            "nsp_cmd.h",
            "cmdz80.h",
            "cmd68k.h",
        },
        .exclude_extensions = &.{"/romdump.h"},
    });
    b.installArtifact(libticalcs2);
}
