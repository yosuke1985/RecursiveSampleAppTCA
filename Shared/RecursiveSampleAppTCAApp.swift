//
//  RecursiveSampleAppTCAApp.swift
//  Shared
//
//  Created by Yosuke NAKAYAMA on 2022/04/15.
//

import SwiftUI

@main
struct RecursiveSampleAppTCAApp: App {
    var body: some Scene {
        WindowGroup<TimelineView> {
            TimelineView(store: .init(initialState: TimelineState(),
                                      reducer: timelineReducer,
                                      environment: .init()))
        }
    }
}
