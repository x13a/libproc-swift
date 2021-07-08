# libproc-swift

Swift wrapper for `libproc` library.

## Example

```swift
import Darwin
import Proc

func main() throws {

    // To get pid path:
    let path = try Proc.pidPath(getpid()).get()
    print(path)
    
    // To list all pids:
    let pids = try Proc.listAllPids().get()
    print(pids)
    
    // To get `proc_bsdinfo`:
    let info = try Proc.pidInfo(proc_bsdinfo.self, getpid(), 0).get()
    print(info)
}

main()
```
