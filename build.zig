const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    //Linux
    const target_linux_x86_64 = std.zig.CrossTarget{ .os_tag = .linux, .cpu_arch = .x86_64 };
    const target_linux_x86 = std.zig.CrossTarget{ .os_tag = .linux, .cpu_arch = .x86 };
    const target_linux_aarch64 = std.zig.CrossTarget{ .os_tag = .linux, .cpu_arch = .aarch64 };
    const target_linux_arm = std.zig.CrossTarget{ .os_tag = .linux, .cpu_arch = .arm };

    //Windows
    const target_windows_x86_64 = std.zig.CrossTarget{ .os_tag = .windows, .cpu_arch = .x86_64 };
    const target_windows_x86 = std.zig.CrossTarget{ .os_tag = .windows, .cpu_arch = .x86 };

    //macOS
    const target_macos_x86_64 = std.zig.CrossTarget{ .os_tag = .macos, .cpu_arch = .x86_64 };
    const target_macos_aarch64 = std.zig.CrossTarget{ .os_tag = .macos, .cpu_arch = .aarch64 };

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "folia-server-builder",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    //Linux
    const linux_x86_64 = b.addExecutable(.{
        .name = "folia-server-builder_linux_x86_64",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_linux_x86_64,
        .optimize = optimize,
    });
    const linux_x86 = b.addExecutable(.{
        .name = "folia-server-builder_linux_x86",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_linux_x86,
        .optimize = optimize,
    });
    const linux_aarch64 = b.addExecutable(.{
        .name = "folia-server-builder_linux_aarch64",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_linux_aarch64,
        .optimize = optimize,
    });
    const linux_arm = b.addExecutable(.{
        .name = "folia-server-builder_linux_arm",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_linux_arm,
        .optimize = optimize,
    });

    //Windows
    const windows_x86_64 = b.addExecutable(.{
        .name = "folia-server-builder_windows_x86_64",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_windows_x86_64,
        .optimize = optimize,
    });
    const windows_x86 = b.addExecutable(.{
        .name = "folia-server-builder_windows_x86",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_windows_x86,
        .optimize = optimize,
    });

    //macOS
    const macos_x86_64 = b.addExecutable(.{
        .name = "folia-server-builder_macos_x86_64",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_macos_x86_64,
        .optimize = optimize,
    });
    const macos_aarch64 = b.addExecutable(.{
        .name = "folia-server-builder_macos_aarch64",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target_macos_aarch64,
        .optimize = optimize,
    });

    b.installArtifact(exe);
    b.installArtifact(linux_x86_64);
    b.installArtifact(linux_x86);
    b.installArtifact(linux_aarch64);
    b.installArtifact(linux_arm);
    b.installArtifact(windows_x86_64);
    b.installArtifact(windows_x86);
    b.installArtifact(macos_x86_64);
    b.installArtifact(macos_aarch64);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const all_step = b.step("all", "Build for All");
    //Linux
    all_step.dependOn(&linux_x86_64.step);
    all_step.dependOn(&linux_x86.step);
    all_step.dependOn(&linux_aarch64.step);
    all_step.dependOn(&linux_arm.step);
    //Windows
    all_step.dependOn(&windows_x86_64.step);
    all_step.dependOn(&windows_x86.step);
    //macOS
    all_step.dependOn(&macos_x86_64.step);
    all_step.dependOn(&macos_aarch64.step);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
