    import XCTest
    @testable import ProcUtils

    final class ProcUtilsTests: XCTestCase {
        func testPpid() throws {
            let ppid = try ProcUtils.ppid(getpid()).get()
            assert(ppid == getppid())
        }
        
        func testCwd() throws {
            let cwd = try ProcUtils.cwd(getpid()).get()
            print(cwd)
        }
    }
