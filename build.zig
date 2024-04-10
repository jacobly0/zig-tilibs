const std = @import("std");

pub fn defineOsMacros(mod: *std.Build.Module) void {
    const target = mod.resolved_target.?.result;
    switch (target.os.tag) {
        .linux => mod.addCMacro("__LINUX__", "1"),
        .macos => mod.addCMacro("__MACOSX__", "1"),
        .windows => mod.addCMacro("__WIN32__", "1"),
        else => if (target.os.tag.isBSD()) {
            mod.addCMacro("__BSD__", "1");
        } else {
            std.log.err("Unsupported OS: {}", .{target});
            mod.owner.invalid_user_input = true;
        },
    }
    if (target.isMinGW()) mod.addCMacro("__MINGW32__", "1");
}

pub fn build(b: *std.Build) void {
    const upstream = b.dependency("tilibs", .{});
    const libarchive = b.dependency("libarchive", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libticonv = b.addStaticLibrary(.{
        .name = "ticonv",
        .target = target,
        .optimize = optimize,
    });
    libticonv.root_module.link_libcpp = true;
    libticonv.root_module.linkSystemLibrary("glib-2.0", .{});
    libticonv.root_module.addCMacro("restrict", "__restrict");
    libticonv.root_module.addCMacro("TICONV_EXPORTS", "");
    libticonv.root_module.addCMacro("VERSION", "\"1.1.6\"");
    defineOsMacros(&libticonv.root_module);
    libticonv.root_module.addCSourceFiles(.{
        .root = upstream.path("libticonv/trunk/src"),
        .files = &.{
            "charset.cc",
            "filename.cc",
            "iconv.c",
            "ticonv.cc",
            "tokens.cc",
            "type2str.cc",
        },
    });
    libticonv.installHeadersDirectory(upstream.path("libticonv/trunk/src"), "", .{
        .include_extensions = &.{
            "charset.h",
            "export4.h",
            "ticonv.h",
        },
    });
    const libticonv_install = b.addInstallArtifact(libticonv, .{});
    b.step("ticonv", "Build libticonv").dependOn(&libticonv_install.step);
    b.getInstallStep().dependOn(&libticonv_install.step);

    const libtifiles2 = b.addStaticLibrary(.{
        .name = "tifiles2",
        .target = target,
        .optimize = optimize,
    });
    libtifiles2.root_module.link_libcpp = true;
    libtifiles2.root_module.linkSystemLibrary("glib-2.0", .{});
    libtifiles2.root_module.linkLibrary(libarchive.artifact("archive"));
    libtifiles2.root_module.linkLibrary(libticonv);
    libtifiles2.root_module.addCMacro("LOCALEDIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, "locale"),
    }));
    libtifiles2.root_module.addCMacro("restrict", "__restrict");
    libtifiles2.root_module.addCMacro("VERSION", "\"1.1.8\"");
    defineOsMacros(&libtifiles2.root_module);
    libtifiles2.root_module.addCSourceFiles(.{
        .root = upstream.path("libtifiles/trunk/src"),
        .files = &.{
            "cert.cc",
            "comments.cc",
            "error.cc",
            "files8x.cc",
            "files9x.cc",
            "filesnsp.cc",
            "filesxx.cc",
            "filetypes.cc",
            "grouped.cc",
            "intelhex.cc",
            "misc.cc",
            "rwfile.cc",
            "tifiles.cc",
            "tigroup.cc",
            "type2str.cc",
            "types68k.cc",
            "types83p.cc",
            "typesnsp.cc",
            "typesoldz80.cc",
            "typesxx.cc",
            "ve_fp.cc",
        },
    });
    libtifiles2.installHeadersDirectory(upstream.path("libtifiles/trunk/src"), "", .{
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
    const libtifiles2_install = b.addInstallArtifact(libtifiles2, .{});
    b.step("tifiles2", "Build libtifiles2").dependOn(&libtifiles2_install.step);
    b.getInstallStep().dependOn(&libtifiles2_install.step);

    const libticables2 = b.addStaticLibrary(.{
        .name = "ticables2",
        .target = target,
        .optimize = optimize,
    });
    libticables2.root_module.link_libcpp = true;
    libticables2.root_module.linkSystemLibrary("glib-2.0", .{});
    libticables2.root_module.linkSystemLibrary("libusb-1.0", .{});
    libticables2.root_module.addCMacro("HAVE_LIBUSB_1_0", "1");
    libticables2.root_module.addCMacro("HAVE_LIBUSB10_STRERROR", "1");
    libticables2.root_module.addCMacro("HAVE_TERMIOS_H", "1");
    libticables2.root_module.addCMacro("LOCALEDIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, "locale"),
    }));
    libticables2.root_module.addCMacro("VERSION", "\"1.3.6\"");
    defineOsMacros(&libticables2.root_module);
    libticables2.root_module.addCSourceFiles(.{
        .root = upstream.path("libticables/trunk/src"),
        .files = &.{
            "data_log.cc",
            "detect.cc",
            "error.cc",
            "hex2dbus.cc",
            "hex2dusb.cc",
            "hex2nsp.cc",
            "ioports.cc",
            "link_blk.cc",
            "link_gry.cc",
            "link_nul.cc",
            "link_par.cc",
            "link_tcpc.cc",
            "link_tcps.cc",
            "link_tie.cc",
            "link_usb.cc",
            "link_vti.cc",
            "link_xxx.cc",
            "log_dbus.cc",
            "log_dusb.cc",
            "log_hex.cc",
            "log_nsp.cc",
            "none.cc",
            "probe.cc",
            "ticables.cc",
            "type2str.cc",
        },
    });
    libticables2.installHeadersDirectory(upstream.path("libticables/trunk/src"), "", .{
        .include_extensions = &.{
            "ticables.h",
            "export1.h",
            "timeout.h",
        },
    });
    const libticables2_install = b.addInstallArtifact(libticables2, .{});
    b.step("ticables2", "Build libticables2").dependOn(&libticables2_install.step);
    b.getInstallStep().dependOn(&libticables2_install.step);

    const libticalcs2 = b.addStaticLibrary(.{
        .name = "ticalcs2",
        .target = target,
        .optimize = optimize,
    });
    libticalcs2.root_module.link_libcpp = true;
    libticalcs2.root_module.linkLibrary(libticonv);
    libticalcs2.root_module.linkLibrary(libtifiles2);
    libticalcs2.root_module.linkLibrary(libticables2);
    libticalcs2.root_module.addCMacro("HAVE_ASCTIME_R", "1");
    libticalcs2.root_module.addCMacro("HAVE_CTIME_R", "1");
    libticalcs2.root_module.addCMacro("HAVE_LOCALTIME_R", "1");
    libticalcs2.root_module.addCMacro("LOCALEDIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, "locale"),
    }));
    libticalcs2.root_module.addCMacro("restrict", "__restrict");
    libticalcs2.root_module.addCMacro("VERSION", "\"1.1.10\"");
    defineOsMacros(&libticalcs2.root_module);
    libticalcs2.root_module.addCSourceFiles(.{
        .root = upstream.path("libticalcs/trunk/src"),
        .files = &.{
            "backup.cc",
            "calc_00.cc",
            "calc_73.cc",
            "calc_84p.cc",
            "calc_89t.cc",
            "calc_8x.cc",
            "calc_9x.cc",
            "calc_nsp.cc",
            "calc_xx.cc",
            "clock.cc",
            "cmd68k.cc",
            "cmdz80.cc",
            "dbus_pkt.cc",
            "dirlist.cc",
            "dusb_cmd.cc",
            "dusb_rpkt.cc",
            "dusb_vpkt.cc",
            "error.cc",
            "keys73.cc",
            "keys83.cc",
            "keys83p.cc",
            "keys86.cc",
            "keys89.cc",
            "keys92p.cc",
            "nsp_cmd.cc",
            "nsp_rpkt.cc",
            "nsp_vpkt.cc",
            "probe.cc",
            "romdump.cc",
            "screen.cc",
            "ticalcs.cc",
            "tikeys.cc",
            "type2str.cc",
            "update.cc",
        },
    });
    libticalcs2.installHeadersDirectory(upstream.path("libticalcs/trunk/src"), "", .{
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
    const libticalcs2_install = b.addInstallArtifact(libticalcs2, .{});
    b.step("ticalcs2", "Build libticalcs2").dependOn(&libticalcs2_install.step);
    b.getInstallStep().dependOn(&libticalcs2_install.step);
}
