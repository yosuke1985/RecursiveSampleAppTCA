//
//  CowWrapper.swift
//  RecursiveSampleAppTCA
//
//  Created by Yosuke NAKAYAMA on 2022/05/04.
//

import Foundation

@propertyWrapper
public struct Cow<T> {
    private final class Ref<T> {
        var val: T
        init(_ v: T) { val = v }
    }

    private var ref: Ref<T>

    public init(_ x: T) { self.init(wrappedValue: x) }
    public init(wrappedValue: T) { ref = Ref(wrappedValue) }

    private var value: T {
        get { ref.val }
        set {
            if !isKnownUniquelyReferenced(&ref) {
                ref = Ref(newValue)
                return
            }
            ref.val = newValue
        }
    }

    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
}

extension Cow: Equatable where T: Equatable {
    public static func == (lhs: Cow<T>, rhs: Cow<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

