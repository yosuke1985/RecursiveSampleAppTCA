//
//  Reducer+Extension.swift
//  RecursiveSampleAppTCA
//
//  Created by Yosuke NAKAYAMA on 2022/05/04.
//

import Foundation
import ComposableArchitecture

extension Reducer {
    static func recurse(
        _ reducer: @escaping (Reducer, inout State, Action, Environment) -> Effect<Action, Never>
    ) -> Reducer {
        var `self`: Reducer!
        self = Reducer { state, action, environment in
            reducer(self, &state, action, environment)
        }
        return self
    }
}

