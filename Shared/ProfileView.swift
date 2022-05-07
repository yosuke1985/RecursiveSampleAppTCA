//
//  ProfileView.swift
//  RecursiveSampleAppTCA
//
//  Created by Yosuke NAKAYAMA on 2022/04/16.
//

import Foundation
import ComposableArchitecture
import SwiftUI


struct ProfileState: Equatable, Identifiable {
    @Cow var id = UUID()
    @Cow var timelineLogCellStateList: IdentifiedArrayOf<TimelineLogCellState> = []
}

enum ProfileAction: Equatable {
    case timelineLogCellAction(index: TimelineLogCellState.ID, action: TimelineLogCellAction)
}

struct ProfileEnvironment {
}

let profileReducer = Reducer<ProfileState, ProfileAction, ProfileEnvironment>.recurse { `self`, state, action, env in
    switch action {
    case .timelineLogCellAction:

        return self.forEach(state: \ProfileState.timelineLogCellStateList,
                            action: /ProfileAction.timelineLogCellAction(index:action:),
                            environment: {_ in ProfileEnvironment() })
                .run(&state, action, env)
    default:
        return .none
    }
}

struct ProfileView: View {
    var store: Store<ProfileState, ProfileAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                timelineView
            }
            .listStyle(PlainListStyle())
        }
    }

    var timelineView: some View {
        WithViewStore(store) { viewStore in
            ForEachStore(
                self.store.scope(
                    state: \.timelineLogCellStateList,
                    action: ProfileAction.timelineLogCellAction(index:action:)
                ),
                content: TimelineLogCell.init(store:)
            )
            .listRowInsets(EdgeInsets())
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            store: .init(
                initialState: .init(),
                reducer: profileReducer,
                environment: ProfileEnvironment()
            ))
    }
}
