const std = @import("std");

const X11 = struct {
    var _impl: ?@This() = null;

    XOpenDisplay: *const fn ([*:0]const u8) ?*anyopaque,
    XCloseDisplay: *const fn (?*anyopaque) c_int,
    XFree: *const fn (?*anyopaque) c_int,
    _XGetRequest: *const fn (?*anyopaque, u8, usize) ?*anyopaque,
    _XReply: *const fn (?*anyopaque, ?*anyopaque, c_int, c_int) c_int,
    _XRead: *const fn (?*anyopaque, ?[*]const u8, c_long) c_int,
    _XEatData: *const fn (?*anyopaque, c_ulong) void,
    _XSend: *const fn (?*anyopaque, ?[*]const u8, c_long) void,
    _XSetLastRequestRead: *const fn (?*anyopaque, ?*anyopaque) c_ulong,

    pub fn get() *const @This() {
        if (_impl) |impl| return &impl;
        var so = std.DynLib.open("libX11.so.6") catch @panic("failed to load libX11.so.6");
        _impl = undefined;
        inline for (std.meta.fields(@This())) |field| {
            @field(_impl.?, field.name) = so.lookup(@FieldType(@This(), field.name), field.name) orelse std.debug.panic("could not resolve: {s}", .{field.name});
        }
        return &_impl.?;
    }
};

export fn XOpenDisplay(display_name: [*:0]const u8) ?*anyopaque {
    return X11.get().XOpenDisplay(display_name);
}

export fn XCloseDisplay(dpy: ?*anyopaque) c_int {
    return X11.get().XCloseDisplay(dpy);
}

export fn XFree(data: ?*anyopaque) c_int {
    return X11.get().XFree(data);
}

export fn _XGetRequest(dpy: ?*anyopaque, kind: u8, len: usize) ?*anyopaque {
    return X11.get()._XGetRequest(dpy, kind, len);
}

export fn _XReply(dpy: ?*anyopaque, reply: ?*anyopaque, extra: c_int, discard: c_int) c_int {
    return X11.get()._XReply(dpy, reply, extra, discard);
}

export fn _XRead(dpy: ?*anyopaque, data: ?[*]const u8, size: c_long) c_int {
    return X11.get()._XRead(dpy, data, size);
}

export fn _XEatData(dpy: ?*anyopaque, size: c_ulong) void {
    return X11.get()._XEatData(dpy, size);
}

export fn _XSend(dpy: ?*anyopaque, data: ?[*]const u8, size: c_long) void {
    return X11.get()._XSend(dpy, data, size);
}

export fn _XSetLastRequestRead(dpy: ?*anyopaque, rep: ?*anyopaque) c_ulong {
    return X11.get()._XSetLastRequestRead(dpy, rep);
}

const Xext = struct {
    var _impl: ?@This() = null;

    XextFindDisplay: *const fn (?*anyopaque, ?*anyopaque) ?*anyopaque,
    XextAddDisplay: *const fn (?*anyopaque, ?*anyopaque, ?[*:0]const u8, ?*anyopaque, c_int, ?*anyopaque) ?*anyopaque,
    XextRemoveDisplay: *const fn (?*anyopaque, ?*anyopaque) c_int,
    XMissingExtension: *const fn (?*anyopaque, ?[*:0]const u8) c_int,

    pub fn get() *const @This() {
        if (_impl) |impl| return &impl;
        var so = std.DynLib.open("libXext.so.6") catch @panic("failed to load libXext.so.6");
        _impl = undefined;
        inline for (std.meta.fields(@This())) |field| {
            @field(_impl.?, field.name) = so.lookup(@FieldType(@This(), field.name), field.name) orelse std.debug.panic("could not resolve: {s}", .{field.name});
        }
        return &_impl.?;
    }
};

export fn XextFindDisplay(extinfo: ?*anyopaque, dpy: ?*anyopaque) ?*anyopaque {
    return Xext.get().XextFindDisplay(extinfo, dpy);
}

export fn XextAddDisplay(extinfo: ?*anyopaque, dpy: ?*anyopaque, ext_name: [*:0]const u8, hooks: ?*anyopaque, nevents: c_int, data: ?*anyopaque) ?*anyopaque {
    return Xext.get().XextAddDisplay(extinfo, dpy, ext_name, hooks, nevents, data);
}

export fn XextRemoveDisplay(extinfo: ?*anyopaque, dpy: ?*anyopaque) c_int {
    return Xext.get().XextRemoveDisplay(extinfo, dpy);
}

export fn XMissingExtension(dpy: ?*anyopaque, ext_name: [*:0]const u8) c_int {
    return Xext.get().XMissingExtension(dpy, ext_name);
}
