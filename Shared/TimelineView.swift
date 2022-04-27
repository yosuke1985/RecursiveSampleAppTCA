//
//  TimelineView.swift
//  RecursiveSampleAppTCA
//
//  Created by Yosuke NAKAYAMA on 2022/04/16.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct TimelineState: Equatable {
    var timelineLogCellStateList: IdentifiedArrayOf<TimelineLogCellState> = []
}

enum TimelineAction: Equatable {
    case timelineLogCellAction(index: UUID, action: TimelineLogCellAction)
}

struct TimelineEnvironment {
}

let timelineReducer = Reducer<TimelineState, TimelineAction, TimelineEnvironment> { state, action, env in
    switch action {
    default:
        return .none
    }
}

struct TimelineView: View {
    var store: Store<TimelineState, TimelineAction>

    var body: some View {
        WithViewStore(store) { _ in
            List {
                ForEachStore(
                    self.store.scope(
                        state: \.timelineLogCellStateList,
                        action: TimelineAction.timelineLogCellAction(index:action:)
                    ),
                    content: TimelineLogCell.init(store:)
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(
            store: Store(
                initialState: TimelineState(),
                reducer: timelineReducer,
                environment: TimelineEnvironment()
            )
        )
    }
}
