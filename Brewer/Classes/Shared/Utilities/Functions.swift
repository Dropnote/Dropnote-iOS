//
// Created by Maciej Oczko on 26.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

func isRunningTests() -> Bool {
    return NSProcessInfo.processInfo().environment["XCInjectBundle"] != nil
}

struct Dispatcher {
    static func delay(delay: Double, closure: () -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}

@noreturn func abstractMethod() {
    fatalError("Override this method")
}
