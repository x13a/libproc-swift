import Darwin

// https://github.com/apple/darwin-xnu/blob/main/bsd/sys/proc_info.h

public protocol ProcProtocolInit {
    init()
}

extension Darwin.proc_fdinfo:             ProcProtocolInit {}
extension Darwin.proc_taskallinfo:        ProcProtocolInit {}
extension Darwin.proc_bsdinfo:            ProcProtocolInit {}
extension Darwin.proc_taskinfo:           ProcProtocolInit {}
extension Darwin.proc_threadinfo:         ProcProtocolInit {}
extension Darwin.proc_regioninfo:         ProcProtocolInit {}
extension Darwin.proc_regionwithpathinfo: ProcProtocolInit {}
extension Darwin.proc_vnodepathinfo:      ProcProtocolInit {}
extension Darwin.proc_threadwithpathinfo: ProcProtocolInit {}
extension Darwin.proc_workqueueinfo:      ProcProtocolInit {}
extension Darwin.proc_bsdshortinfo:       ProcProtocolInit {}
extension Darwin.proc_fileportinfo:       ProcProtocolInit {}
extension Darwin.vnode_fdinfo:            ProcProtocolInit {}
extension Darwin.vnode_fdinfowithpath:    ProcProtocolInit {}
extension Darwin.socket_fdinfo:           ProcProtocolInit {}
extension Darwin.psem_fdinfo:             ProcProtocolInit {}
extension Darwin.pshm_fdinfo:             ProcProtocolInit {}
extension Darwin.pipe_fdinfo:             ProcProtocolInit {}
extension Darwin.kqueue_fdinfo:           ProcProtocolInit {}
extension Darwin.appletalk_fdinfo:        ProcProtocolInit {}

// list threads
extension UInt64: ProcProtocolInit {}

public protocol ProcProtocolBase {
    associatedtype Item: ProcProtocolInit
    static func flavor() -> Int32
}

public protocol ProcProtocolInfo:         ProcProtocolBase {}
public protocol ProcProtocolListInfo:     ProcProtocolBase {}
public protocol ProcProtocolFdInfo:       ProcProtocolBase {}
public protocol ProcProtocolFilePortInfo: ProcProtocolBase {}

public struct proc_taskallinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_taskallinfo
    public static func flavor() -> Int32 { PROC_PIDTASKALLINFO }
}

public struct proc_bsdinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_bsdinfo
    public static func flavor() -> Int32 { PROC_PIDTBSDINFO }
}

public struct proc_taskinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_taskinfo
    public static func flavor() -> Int32 { PROC_PIDTASKINFO }
}

public struct proc_threadinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_threadinfo
    public static func flavor() -> Int32 { PROC_PIDTHREADINFO }
}

public struct proc_regioninfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_regioninfo
    public static func flavor() -> Int32 { PROC_PIDREGIONINFO }
}

public struct proc_regionwithpathinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_regionwithpathinfo
    public static func flavor() -> Int32 { PROC_PIDREGIONPATHINFO }
}

public struct proc_vnodepathinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_vnodepathinfo
    public static func flavor() -> Int32 { PROC_PIDVNODEPATHINFO }
}

public struct proc_threadwithpathinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_threadwithpathinfo
    public static func flavor() -> Int32 { PROC_PIDTHREADPATHINFO }
}

public struct proc_workqueueinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_workqueueinfo
    public static func flavor() -> Int32 { PROC_PIDWORKQUEUEINFO }
}

public struct proc_bsdshortinfo: ProcProtocolInfo {
    public typealias Item = Darwin.proc_bsdshortinfo
    public static func flavor() -> Int32 { PROC_PIDT_SHORTBSDINFO }
}

public struct proc_thread64info: ProcProtocolInfo {
    public typealias Item = Darwin.proc_threadinfo
    public static func flavor() -> Int32 { PROC_PIDTHREADID64INFO }
}

public struct list_proc_fdinfo: ProcProtocolListInfo {
    public typealias Item = Darwin.proc_fdinfo
    public static func flavor() -> Int32 { PROC_PIDLISTFDS }
}

public struct list_proc_threads: ProcProtocolListInfo {
    public typealias Item = UInt64
    public static func flavor() -> Int32 { PROC_PIDLISTTHREADS }
}

public struct list_proc_fileportinfo: ProcProtocolListInfo {
    public typealias Item = Darwin.proc_fileportinfo
    public static func flavor() -> Int32 { PROC_PIDLISTFILEPORTS }
}

public struct fd_vnode_fdinfo: ProcProtocolFdInfo {
    public typealias Item = Darwin.vnode_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFDVNODEINFO }
}

public struct fd_vnode_fdinfowithpath: ProcProtocolFdInfo {
    public typealias Item = Darwin.vnode_fdinfowithpath
    public static func flavor() -> Int32 { PROC_PIDFDVNODEPATHINFO }
}

public struct fd_socket_fdinfo: ProcProtocolFdInfo {
    public typealias Item = Darwin.socket_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFDSOCKETINFO }
}

public struct fd_psem_fdinfo: ProcProtocolFdInfo {
    public typealias Item = Darwin.psem_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFDPSEMINFO }
}

public struct fd_pshm_fdinfo: ProcProtocolFdInfo {
    public typealias Item = Darwin.pshm_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFDPSHMINFO }
}

public struct fd_pipe_fdinfo: ProcProtocolFdInfo {
    public typealias Item = Darwin.pipe_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFDPIPEINFO }
}

public struct fd_kqueue_fdinfo: ProcProtocolFdInfo {
    public typealias Item = Darwin.kqueue_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFDKQUEUEINFO }
}

public struct fd_appletalk_fdinfo: ProcProtocolFdInfo {
    public typealias Item = Darwin.appletalk_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFDATALKINFO }
}

public struct fileport_vnode_fdinfowithpath: ProcProtocolFilePortInfo {
    public typealias Item = Darwin.vnode_fdinfowithpath
    public static func flavor() -> Int32 { PROC_PIDFILEPORTVNODEPATHINFO }
}

public struct fileport_socket_fdinfo: ProcProtocolFilePortInfo {
    public typealias Item = Darwin.socket_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFILEPORTSOCKETINFO }
}

public struct fileport_pshm_fdinfo: ProcProtocolFilePortInfo {
    public typealias Item = Darwin.pshm_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFILEPORTPSHMINFO }
}

public struct fileport_pipe_fdinfo: ProcProtocolFilePortInfo {
    public typealias Item = Darwin.pipe_fdinfo
    public static func flavor() -> Int32 { PROC_PIDFILEPORTPIPEINFO }
}
