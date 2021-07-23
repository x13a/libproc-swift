    import XCTest
    @testable import Proc

    final class ProcTests: XCTestCase {
        func testPidPath() throws {
            let path = try Proc.pidPath(getpid()).get()
            print(path)
        }
        
        func testListAllPids() throws {
            let pids = try Proc.listAllPids().get()
            print(pids)
        }
        
        func testListPgrpPids() throws {
            let pids = try Proc.listPgrpPids(getppid()).get()
            print(pids)
        }
        
        func testListChildPids() throws {
            let pids = try Proc.listChildPids(getppid()).get()
            print(pids)
        }
        
        func testName() throws {
            let name = try Proc.name(getpid()).get()
            print(name)
        }
        
        func testPidInfo() throws {
            let pid = getpid()
            let taskAllInfo = try Proc.pidInfo(proc_taskallinfo.self, pid, 0).get()
            let bsdInfo = try Proc.pidInfo(proc_bsdinfo.self, pid, 0).get()
            let taskInfo = try Proc.pidInfo(proc_taskinfo.self, pid, 0).get()
//            let threadInfo = try Proc.pidInfo(proc_threadinfo.self, pid, 0).get()
            let regionInfo = try Proc.pidInfo(proc_regioninfo.self, pid, 0).get()
            let regionWithPathInfo = try Proc.pidInfo(proc_regionwithpathinfo.self, pid, 0).get()
            let vnodePathInfo = try Proc.pidInfo(proc_vnodepathinfo.self, pid, 0).get()
//            let threadWithPathInfo = try Proc.pidInfo(proc_threadwithpathinfo.self, pid, 0).get()
            let workQueueInfo = try Proc.pidInfo(proc_workqueueinfo.self, pid, 0).get()
            let bsdShortInfo = try Proc.pidInfo(proc_bsdshortinfo.self, pid, 0).get()
//            let thread64Info = try Proc.pidInfo(proc_thread64info.self, pid, 0).get()
            
            print(taskAllInfo)
            print(bsdInfo)
            print(taskInfo)
//            print(threadInfo)
            print(regionInfo)
            print(regionWithPathInfo)
            print(vnodePathInfo)
//            print(threadWithPathInfo)
            print(workQueueInfo)
            print(bsdShortInfo)
//            print(thread64Info)
            
        }
    }
