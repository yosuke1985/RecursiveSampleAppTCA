//
//  TCARecursionApp.swift
//  RecursiveSampleAppTCA
//
//  Created by Yosuke NAKAYAMA on 2022/04/28.
//

import Foundation
import ComposableArchitecture
import SwiftUI

//@main
//struct TCARecursionApp: App {
//    var body: some Scene {
//        WindowGroup {
//            HomeView(store: .init(initialState: HomeState(), reducer: homeReducer, environment: HomeEnvironment(uuid: UUID.init)))
//        }
//    }
//}

// MARK: - Home

struct HomeState: Equatable {
    @Cow var isAActive = false
    @Cow var screenA: ScreenAState?
}

enum HomeAction: Equatable {
    case screenA(ScreenAAction)
    case setScreenA(isActive: Bool)
}

struct HomeEnvironment {
    var uuid: () -> UUID
}

let homeReducer: Reducer<HomeState, HomeAction, HomeEnvironment> =  Reducer.combine(
    screenAReducer
        .optional()
        .pullback(
            state: \HomeState.screenA,
            action: /HomeAction.screenA,
            environment: { ScreenAEnvironment(uuid: $0.uuid) }
        ),
    Reducer<HomeState, HomeAction, HomeEnvironment> { state, action, environment in
        switch action {
        case .screenA:
            return .none

        case .setScreenA(isActive: true):
            state.isAActive = true
            state.screenA = .init(id: environment.uuid())
            return .none

        case .setScreenA(isActive: false):
            state.isAActive = false
            state.screenA = nil
            return .none
        }
    }
)

struct HomeView: View {
    let store: Store<HomeState, HomeAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    NavigationLink(
                        "Screen A",
                        destination: IfLetStore(
                            self.store.scope(
                                state: \.screenA,
                                action: HomeAction.screenA
                            ),
                            then: ScreenA.init(store:),
                            else: ProgressView.init
                        ),
                        isActive: viewStore.binding(
                            get: \.isAActive,
                            send: HomeAction.setScreenA(isActive:)
                        )
                    ).isDetailLink(false)
                }
                .navigationBarTitle("Home Screen")
            }
        }
    }
}

// MARK: - Screen A

struct ScreenAState: Equatable, Identifiable {
    @Cow var id: UUID
    @Cow var isAActive = false
    @Cow var isBActive = false
    @Cow var screenA: ScreenAState?
    @Cow var screenB: ScreenBState?
}

indirect enum ScreenAAction: Equatable {
    case screenA(ScreenAAction)
    case screenB(ScreenBAction)
    case setScreenA(isActive: Bool)
    case setScreenB(isActive: Bool)
}

struct ScreenAEnvironment {
    var uuid: () -> UUID
}

let screenAReducer: Reducer<ScreenAState, ScreenAAction, ScreenAEnvironment> = Reducer<
    ScreenAState, ScreenAAction, ScreenAEnvironment
>.combine(
    .recurse { `self`, state, action, environment in
        switch action {
        case .screenA:
            return self
                .optional()
                .pullback(
                    state: \.screenA,
                    action: /ScreenAAction.screenA,
                    environment: { $0 }
                )
                .run(&state, action, environment)

        case .screenB:
            return screenBReducer
                .optional()
                .pullback(
                    state: \ScreenAState.screenB,
                    action: /ScreenAAction.screenB,
                    environment: { ScreenBEnvironment(uuid: $0.uuid) }
                )
                .run(&state, action, environment)

        case .setScreenA(isActive: true):
            state.isAActive = true
            state.screenA = .init(id: environment.uuid())
            return .none

        case .setScreenA(isActive: false):
            state.isAActive = false
            state.screenA = nil
            return .none

        case .setScreenB(isActive: true):
            state.isBActive = true
            state.screenB = .init(id: environment.uuid())
            return .none

        case .setScreenB(isActive: false):
            state.isBActive = false
            state.screenB = nil
            return .none
        }
    }
)

struct ScreenA: View {
    let store: Store<ScreenAState, ScreenAAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                NavigationLink(
                    "Screen A",
                    destination: IfLetStore(
                        self.store.scope(
                            state: \.screenA,
                            action: ScreenAAction.screenA
                        ),
                        then: ScreenA.init(store:),
                        else: ProgressView.init
                    ),
                    isActive: viewStore.binding(
                        get: \.isAActive,
                        send: ScreenAAction.setScreenA(isActive:)
                    )
                )
                .isDetailLink(false)

                NavigationLink(
                    "Screen B",
                    destination: IfLetStore(
                        self.store.scope(
                            state: \.screenB,
                            action: ScreenAAction.screenB
                        ),
                        then: ScreenB.init(store:),
                        else: ProgressView.init
                    ),
                    isActive: viewStore.binding(
                        get: \.isBActive,
                        send: ScreenAAction.setScreenB(isActive:)
                    )
                )
                .isDetailLink(false)
            }
            .navigationBarTitle("Screen A")
        }
    }
}

// MARK: - Screen B

struct ScreenBState: Equatable, Identifiable {
    @Cow var id: UUID
    @Cow var isAActive = false
    @Cow var screenA: ScreenAState?
}

indirect enum ScreenBAction: Equatable {
    case screenA(ScreenAAction)
    case setScreenA(isActive: Bool)
}

struct ScreenBEnvironment {
    var uuid: () -> UUID
}

let screenBReducer: Reducer<ScreenBState, ScreenBAction, ScreenBEnvironment> = Reducer.combine(
    screenAReducer
        .optional()
        .pullback(
            state: \ScreenBState.screenA,
            action: /ScreenBAction.screenA,
            environment: { ScreenAEnvironment(uuid: $0.uuid) }
        ),
    Reducer<ScreenBState, ScreenBAction, ScreenBEnvironment> { state, action, environment in
        switch action {
        case .screenA:
            return .none

        case .setScreenA(isActive: true):
            state.isAActive = true
            state.screenA = .init(id: environment.uuid())
            return .none

        case .setScreenA(isActive: false):
            state.isAActive = false
            state.screenA = nil
            return .none
        }
    }
)

struct ScreenB: View {
    let store: Store<ScreenBState, ScreenBAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                NavigationLink(
                    "Screen A",
                    destination: IfLetStore(
                        self.store.scope(
                            state: \.screenA,
                            action: ScreenBAction.screenA
                        ),
                        then: ScreenA.init(store:),
                        else: ProgressView.init
                    ),
                    isActive: viewStore.binding(
                        get: \.isAActive,
                        send: ScreenBAction.setScreenA(isActive:)
                    )
                )
                .isDetailLink(false)
            }
            .navigationBarTitle("Screen B")
        }
    }
}
