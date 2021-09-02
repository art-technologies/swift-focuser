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
