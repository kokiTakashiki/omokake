//
//  CaseIterable+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import Foundation

extension CaseIterable where Self: Equatable & RawRepresentable {
    private var allCases: AllCases { Self.allCases }

    /// **Returns** the next case in the enumeration.
    ///
    /// If the current case is the last one, returns the same case.
    ///
    /// - Returns: The next case or the current case if it's the last one.
    /// - Complexity: O(n) where n is the number of cases in the enumeration.
    func next() -> Self {
        let index = allCases.firstIndex(of: self)!
        let next = allCases.index(after: index)
        guard next != allCases.endIndex else { return allCases[index] }
        return allCases[next]
    }

    /// **Returns** the previous case in the enumeration.
    ///
    /// If the current case is the first one, returns the same case.
    ///
    /// - Returns: The previous case or the current case if it's the first one.
    /// - Complexity: O(n) where n is the number of cases in the enumeration.
    func previous() -> Self {
        let index = allCases.firstIndex(of: self)!
        let previous = allCases.index(index, offsetBy: -1)
        guard previous >= allCases.startIndex else { return allCases[index] }
        return allCases[previous]
    }

    /// **All raw values** of the enumeration cases.
    ///
    /// - Complexity: O(n) where n is the number of cases in the enumeration.
    static var allValues: [RawValue] {
        allCases.map(\.rawValue)
    }
}
