//
//  ArrayExtension.swift
//  Umbala-Interview-Test
//
//  Created by Nguyen Van Uy on 4/13/18.
//  Copyright © 2018 Uy Nguyen Van. All rights reserved.
//

import Foundation

// MARK: - Array
public extension Array {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (atIndex index: Index) -> Iterator.Element? {
        if index < 0 || index >= self.count { return nil }
        return self[index]
    }
}

