//
//  File.swift
//  
//
//  Created by Augustinas Malinauskas on 01/09/2021.
//

import Foundation

public protocol FocusStateCompliant: Hashable {
    static var last: Self { get }
    var next: Self? { get }
}

public extension FocusStateCompliant where Self: CaseIterable, AllCases: BidirectionalCollection {

    static var last: Self {
        return Self.allCases.last! //swiftlint:disable:this force_unwrapping
    }

    var next: Self? {
        let all = Self.allCases
        let index = all.firstIndex(of: self)! //swiftlint:disable:this force_unwrapping
        let next = all.index(after: index)
        return next == all.endIndex ? nil : all[next]
    }

}
