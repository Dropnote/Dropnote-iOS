//
// Created by Maciej Oczko on 25.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation

protocol KeyValueStoreType {
    func objectForKey(_ key: String) -> AnyObject?
    func setObject(_ value: AnyObject?, forKey key: String)
    func removeObjectForKey(_ key: String)
    func synchronize() -> Bool
}
