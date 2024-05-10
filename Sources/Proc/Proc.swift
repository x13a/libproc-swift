import Swift
import Darwin

@_implementationOnly
import Clibproc

// https://github.com/apple/darwin-xnu/blob/main/libsyscall/wrappers/libproc/libproc.c

public struct Proc {
    
    public static let PIDPATHINFO_MAXSIZE = 4 * MAXPATHLEN
    
    public enum Error: Swift.Error {
        case rv(Int32)
    }
    
    public enum PidsType: RawRepresentable {
        public typealias RawValue = Int32
        
        case allPids
        case pgrpOnly
        case ttyOnly
        case uidOnly
        case ruidOnly
        case ppidOnly
        case kdbgOnly
        
        public init?(rawValue: Int32) {
            switch rawValue {
            case PROC_ALL_PIDS:  self = .allPids
            case PROC_PGRP_ONLY: self = .pgrpOnly
            case PROC_TTY_ONLY:  self = .ttyOnly
            case PROC_UID_ONLY:  self = .uidOnly
            case PROC_RUID_ONLY: self = .ruidOnly
            case PROC_PPID_ONLY: self = .ppidOnly
            case PROC_KDBG_ONLY: self = .kdbgOnly
            default: return nil
            }
        }
        
        public var rawValue: Int32 {
            switch self {
            case .allPids:  return PROC_ALL_PIDS
            case .pgrpOnly: return PROC_PGRP_ONLY
            case .ttyOnly:  return PROC_TTY_ONLY
            case .uidOnly:  return PROC_UID_ONLY
            case .ruidOnly: return PROC_RUID_ONLY
            case .ppidOnly: return PROC_PPID_ONLY
            case .kdbgOnly: return PROC_KDBG_ONLY
            }
        }
    }
    
    public static func pidPath(_ pid: pid_t) -> Result<String, Error> {
        var buffer = [CChar](repeating: 0, count: Int(PIDPATHINFO_MAXSIZE))
        let rv = proc_pidpath(pid, &buffer, UInt32(buffer.count))
        return rv > 0 ? .success(String(cString: buffer)) : .failure(.rv(rv))
    }
    
    public static func listPids(
        _ type: PidsType,
        _ typeInfo: UInt32
    ) -> Result<[pid_t], Error> {
        let rawType = UInt32(type.rawValue)
        var bufferSize = proc_listpids(rawType, typeInfo, nil, 0)
        guard bufferSize >= 0 else {
            return .failure(.rv(bufferSize))
        }
        guard bufferSize > 0 else {
            return .success([])
        }
        let pidSize = MemoryLayout<pid_t>.stride
        var pids = [pid_t](repeating: 0, count: Int(bufferSize) / pidSize)
        bufferSize = proc_listpids(
            rawType,
            typeInfo,
            &pids,
            bufferSize
        )
        return bufferSize >= 0 ?
            .success(Array(pids[0..<Int(bufferSize) / pidSize])) :
            .failure(.rv(bufferSize))
    }
    
    public static func listAllPids() -> Result<[pid_t], Error> {
        return listPids(.allPids, 0)
    }
    
    public static func listPgrpPids(_ pid: pid_t) -> Result<[pid_t], Error> {
        return listPids(.pgrpOnly, UInt32(pid))
    }
    
    public static func listChildPids(_ pid: pid_t) -> Result<[pid_t], Error> {
        return listPids(.ppidOnly, UInt32(pid))
    }
    
    public static func name(_ pid: pid_t) -> Result<String, Error> {
        var buffer = [CChar](
            repeating: 0,
            count: MemoryLayout.size(ofValue: proc_bsdinfo.Item().pbi_name)
        )
        let rv = proc_name(pid, &buffer, UInt32(buffer.count))
        return rv > 0 ? .success(String(cString: buffer)) : .failure(.rv(rv))
    }
    
    public static func regionFileName(
        _ pid: pid_t,
        _ address: UInt64
    ) -> Result<String, Error> {
        var buffer = [CChar](repeating: 0, count: Int(MAXPATHLEN))
        let rv = proc_regionfilename(
            pid,
            address,
            &buffer,
            UInt32(buffer.count)
        )
        return rv > 0 ? .success(String(cString: buffer)) : .failure(.rv(rv))
    }
    
    public static func pidInfo<T: ProcProtocolInfo>(
        _: T.Type,
        _ pid: pid_t,
        _ arg: UInt64
    ) -> Result<T.Item, Error> {
        var buffer = T.Item()
        let rv = proc_pidinfo(
            pid,
            T.flavor(),
            arg,
            &buffer,
            Int32(MemoryLayout.size(ofValue: buffer))
        )
        return rv > 0 ? .success(buffer) : .failure(.rv(rv))
    }
    
    public static func listPidInfo<T: ProcProtocolListInfo>(
        _: T.Type,
        _ pid: pid_t,
        _ arg: UInt64
    ) -> Result<[T.Item], Error> {
        let flavor = T.flavor()
        var bufferSize = proc_pidinfo(pid, flavor, arg, nil, 0)
        guard bufferSize >= 0 else {
            return .failure(.rv(bufferSize))
        }
        guard bufferSize > 0 else {
            return .success([])
        }
        let itemSize = MemoryLayout<T.Item>.stride
        var buffer = Array(
            repeating: T.Item(),
            count: Int(bufferSize) / itemSize
        )
        bufferSize = proc_pidinfo(pid, flavor, arg, &buffer, bufferSize)
        return bufferSize >= 0 ?
            .success(Array(buffer[0..<Int(bufferSize) / itemSize])) :
            .failure(.rv(bufferSize))
    }
    
    public static func listThreads(
        _ pid: pid_t,
        _ arg: UInt64
    ) -> Result<[UInt64], Error> {
        var threadNum: Int32 = 0
        switch pidInfo(proc_taskinfo.self, pid, arg) {
        case .success(let info): threadNum = info.pti_threadnum
        case .failure(let err): return .failure(err)
        }
        guard threadNum > 0 else {
            return .success([])
        }
        var buffer = [UInt64](repeating: 0, count: Int(threadNum))
        let itemSize = MemoryLayout<UInt64>.stride
        let bufferSize = proc_pidinfo(
            pid,
            PROC_PIDLISTTHREADS,
            arg,
            &buffer,
            Int32(itemSize * buffer.count)
        )
        return bufferSize >= 0 ?
            .success(
                Array(buffer[0..<Int(bufferSize) / itemSize])
                    .filter { $0 != 0 }) :
            .failure(.rv(bufferSize))
    }

    public static func pidFdInfo<T: ProcProtocolFdInfo>(
        _: T.Type,
        _ pid: pid_t,
        _ fd: Int32
    ) -> Result<T.Item, Error> {
        var buffer = T.Item()
        let rv = proc_pidfdinfo(
            pid,
            fd,
            T.flavor(),
            &buffer,
            Int32(MemoryLayout.size(ofValue: buffer))
        )
        return rv > 0 ? .success(buffer) : .failure(.rv(rv))
    }

    public static func pidFilePortInfo<T: ProcProtocolFilePortInfo>(
        _: T.Type,
        _ pid: pid_t,
        _ filePort: UInt32
    ) -> Result<T.Item, Error> {
        var buffer = T.Item()
        let rv = proc_pidfileportinfo(
            pid,
            filePort,
            T.flavor(),
            &buffer,
            Int32(MemoryLayout.size(ofValue: buffer))
        )
        return rv > 0 ? .success(buffer) : .failure(.rv(rv))
    }
}
