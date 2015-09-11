
import Cocoa


class Test {
    lazy private var serialQueue:dispatch_queue_t = {
        print("serial CREATE")
        return dispatch_queue_create("com.chaoticmoon.queues.singleton.worker.serial", DISPATCH_QUEUE_SERIAL)
        }()
    lazy private var concurrentQueue:dispatch_queue_t = {
        print("concurrent CREATE")
        return dispatch_queue_create("com.chaoticmoon.queues.singleton.worker.concurrent", DISPATCH_QUEUE_CONCURRENT)
        }()
    
    func workerQueue(concurrent concurrent: Bool) -> dispatch_queue_t {
        if concurrent {
            print("concurrent GET")
            return concurrentQueue
        } else {
            print("serial GET")
            return serialQueue
        }
    }
}

//let test1 = Test()
//test1.workerQueue(concurrent: false)
//test1.workerQueue(concurrent: false)