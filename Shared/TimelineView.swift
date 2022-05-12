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
    var timelineLogCellStateList: IdentifiedArrayOf<TimelineLogCellState> = [.init(), .init(), .init()]
}

enum TimelineAction: Equatable {
    case timelineLogCellAction(index: UUID, action: TimelineLogCellAction)
}

struct TimelineEnvironment {
}

let timelineReducer = Reducer<TimelineState, TimelineAction, TimelineEnvironment>.combine(
    timelineLogCellStateReducer.forEach(state: \.timelineLogCellStateList,
                                        action: /TimelineAction.timelineLogCellAction(index: action:),
                                        environment: { _ in TimelineLogCellEnvironment()} )
)
    .debug()

struct TimelineView: View {
    var store: Store<TimelineState, TimelineAction>

    var body: some View {
        WithViewStore(store) { _ in
            NavigationView {
                VStack {
                    ForEachStore(
                        self.store.scope(
                            state: \.timelineLogCellStateList,
                            action: TimelineAction.timelineLogCellAction(index:action:)
                        ),
                        content: TimelineLogCell.init(store:)
                    )
                }
                .navigationTitle("TimelineView")
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
