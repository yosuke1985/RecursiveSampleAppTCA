//
//  TimelineLogCell.swift
//  RecursiveSampleAppTCA
//
//  Created by Yosuke NAKAYAMA on 2022/04/16.
//

import Foundation
import SwiftUI
import ComposableArchitecture


struct TimelineLogCellState: Equatable, Identifiable {
    var id: UUID = UUID()
    var profileState: ProfileState? = nil
}

indirect enum TimelineLogCellAction: Equatable {
    case profileViewDismissed
    case profileAction(ProfileAction)
}


struct TimelineLogCellEnvironment {
}

let timelineLogCellStateReducer = Reducer<TimelineLogCellState,
                                          TimelineLogCellAction,
                                          TimelineLogCellEnvironment> { state, action, env in
                                              switch action {
                                              case .profileViewDismissed:
                                                  state.profileState = nil
                                                  return .none
                                              case .profileAction:
                                                  return profileReducer.optional().pullback(
                                                    state: \TimelineLogCellState.profileState,
                                                    action: /TimelineLogCellAction.profileAction,
                                                    environment: { _ in ProfileEnvironment() }
                                                  )
                                                  .run(&state, action, env)
                                              }
                                          }

struct TimelineLogCell: View {
    var store: Store<TimelineLogCellState, TimelineLogCellAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .center) {
                cellHeader
            }
        }
    }

    private var cellHeader: some View {
        WithViewStore(store) { viewStore in
            HStack {
                NavigationLink(
                    destination:
                        IfLetStore(
                            store.scope(
                                state: \.profileState,
                                action: TimelineLogCellAction.profileAction
                            ),
                            then: ProfileView.init(store:)
                        ),
                    isActive: viewStore.binding(
                        get: { $0.profileState != nil },
                        send: .profileViewDismissed
                    )
                ) {
                    EmptyView()
                }
                .hidden()
                
                Spacer()
            }
        }
    }
}

struct TimelineCell_Previews: PreviewProvider {
    static var previews: some View {
        TimelineLogCell(
            store: .init(initialState: .init(),
                         reducer: timelineLogCellStateReducer,
                         environment: TimelineLogCellEnvironment()
                        )
        )
    }
}
