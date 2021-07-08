import Darwin

import Proc

public struct ProcUtils {
    
    public static func ppid(_ pid: pid_t) -> Result<pid_t, Proc.Error> {
        switch Proc.pidInfo(proc_bsdshortinfo.self, pid, 0) {
        case .success(let info):
            return .success(pid_t(info.pbsi_ppid))
        case .failure(let err):
            return .failure(err)
        }
    }
    
    public static func cwd(_ pid: pid_t) -> Result<String, Proc.Error> {
        switch Proc.pidInfo(proc_vnodepathinfo.self, pid, 0) {
        case .success(let info):
            var vip_path = info.pvi_cdir.vip_path
            return .success(String(cString: &vip_path.0))
        case .failure(let err):
            return .failure(err)
        }
    }
}
