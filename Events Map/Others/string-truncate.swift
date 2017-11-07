//
//  string-truncate.swift
//  Events Map
//
//  Created by Alan Luo on 11/5/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import Foundation

extension String {
    /*
     https://gist.github.com/budidino/8585eecd55fd4284afaaef762450f98e
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.
     
     - Returns: 'String' object.
     */
    func trunc(_ length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
