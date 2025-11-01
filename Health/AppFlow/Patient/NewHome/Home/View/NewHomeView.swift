//
//  NewHomeView.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/04/2025.
//

import SwiftUI

struct NewHomeView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel: NewHomeViewModel
    @EnvironmentObject var profileViewModel: EditProfileViewModel

    // UI-only state
    @State private var selectedPackage: FeaturedPackageItemM?
    @State private var isRescheduling: Bool = false

    // Active tab for MostViewed/Booked
    @State private var mostTab: MostViewedBooked.mostcases = .mostviewed

    // MARK: - Lightweight Equatable ViewState for subviews
    // These structs carry only the minimal, comparable "fingerprints" that matter to the subviews.
    // When the fingerprint arrays don't change, SwiftUI can skip re-rendering those subviews.

    // VIP Packages section state
    private struct VipPackagesViewState: Equatable {
        let fingerprints: [String]
    }

    // MostViewed/Booked section state
    private struct PackagesListViewState: Equatable {
        let fingerprints: [String]
    }

    // Measurements section state
    private struct MeasurementsViewState: Equatable {
        let fingerprints: [String]
    }

    // Produce a stable string that reflects all user-visible fields used by package cells.
    // If any of these fields change, the fingerprint changes -> view will re-render.
    private func fingerprint(for item: FeaturedPackageItemM) -> String {
        [
            String(describing: item.appCountryPackageId),
            String(describing: item.isWishlist),
            String(describing: item.name),
            String(describing: item.homeImage ?? item.imagePath),
            String(describing: item.categoryName),
            String(describing: item.mainCategoryName),
            String(describing: item.sessionCount),
            String(describing: item.priceAfterDiscount),
            String(describing: item.priceBeforeDiscount),
            String(describing: item.discount)
        ].joined(separator: "|")
    }

    // Produce a stable string for a measurement row (only fields that affect UI)
    private func fingerprint(for m: MyMeasurementsStatsM) -> String {
        [
            String(describing: m.medicalMeasurementID),
            String(describing: m.title),
            String(describing: m.lastMeasurementValue),
            String(describing: m.formatteddate),
            String(describing: m.measurementsCount),
            String(describing: m.image),
            String(describing: m.normalRangValue)
        ].joined(separator: "|")
    }

    // Derived states for EquatableByValue
    private var vipPackagesState: VipPackagesViewState {
        let items = viewModel.featuredPackages?.items ?? []
        return VipPackagesViewState(fingerprints: items.map(fingerprint(for:)))
    }

    // Active MostViewed/Booked list state (depends on selected tab)
    private var mostListState: PackagesListViewState {
        let items: [FeaturedPackageItemM] = {
            switch mostTab {
            case .mostviewed:
                return viewModel.mostViewedPackages ?? []
            case .mostbooked:
                return viewModel.mostBookedPackages ?? []
            }
        }()
        return PackagesListViewState(fingerprints: items.map(fingerprint(for:)))
    }

    private var measurementsState: MeasurementsViewState {
        let items = viewModel.myMeasurements ?? []
        return MeasurementsViewState(fingerprints: items.map(fingerprint(for:)))
    }

    // Active packages array for the MostViewed/Booked section (used in the View body)
    private var activeMostPackages: [FeaturedPackageItemM] {
        switch mostTab {
        case .mostviewed:
            return viewModel.mostViewedPackages ?? []
        case .mostbooked:
            return viewModel.mostBookedPackages ?? []
        }
    }

    // Default init
    init() {
        _viewModel = StateObject(wrappedValue: NewHomeViewModel())
    }

    // Test/preview-friendly init (dependency injection)
    init(viewModel: NewHomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            TitleBar(title: "home_navtitle")

            ScrollView(showsIndicators: false) {
                HeaderView()
                    .environmentObject(profileViewModel)
                    .padding(.horizontal)
                    .accessibilityIdentifier("home_header")

                VStack(alignment: .leading) {
                    if let nextsession = viewModel.upcomingSession {
                        NextSessionSection(
                            upcomingSession: nextsession,
                            detailsAction: {},
                            rescheduleAction: { isRescheduling = true }
                        )
                        .padding(.horizontal)
                        .accessibilityIdentifier("home_next_session")
                    }
                    
                    MainCategoriesSection(categories: viewModel.homeCategories) { category in
                        router.push(PackagesView(mainCategory: category))
                    } loadMore:{
                    Task {
                        await viewModel.loadMoreCategoriesIfNeeded()
                    }
                }
                    

                    Image(.adsbg)
                        .resizable()
                        .frame(height: 137)
                        .padding(.horizontal)

                    if Helper.shared.CheckIfLoggedIn(){
                        // Last measurements wrapped with EquatableByValue
                        EquatableByValue(value: measurementsState) {
                            LastMesurmentsSection(measurements: viewModel.myMeasurements) { item in
                                guard let item = item else { return }
                                router.push(MeasurementDetailsView(stat: item))
                            }
                            .accessibilityIdentifier("home_measurements_section")
                        }
                    }

                    // VIP packages wrapped with EquatableByValue
                    EquatableByValue(value: vipPackagesState) {
                        VipPackagesSection(
                            packages: viewModel.featuredPackages?.items,
                            selectedPackage: $selectedPackage,
                            likeAction: { packageId in
                                Task { await viewModel.toggleWishlist(for: packageId, in: .featured) }
                            }
                        )
                        .accessibilityIdentifier("home_vip_section")
                    }

                    Image(.adsbg2)
                        .resizable()
                        .frame(height: 229)
                        .padding(.horizontal)

                    // Most viewed/booked wrapped with EquatableByValue keyed to the active list
                    EquatableByValue(value: mostListState) {
                        MostViewedBooked(
                            currentcase: $mostTab,
                            packaces: activeMostPackages,
                            selectedPackage: $selectedPackage,
                            likeAction: { packageId, currentcase in
                                Task {
                                    switch currentcase {
                                    case .mostviewed:
                                        await viewModel.toggleWishlist(for: packageId, in: .mostViewed)
                                    case .mostbooked:
                                        await viewModel.toggleWishlist(for: packageId, in: .mostBooked)
                                    }
                                }
                            },
                            onChangeTab: { newTab in
                                // Update selection and fetch the corresponding list
                                mostTab = newTab
                                Task {
                                    await viewModel.getMostBookedOrViewedPackages(
                                        forcase: newTab == .mostviewed ? .MostViewed : .MostBooked
                                    )
                                }
                            }
                        )
                        .accessibilityIdentifier("home_most_section")
                    }
                }

                Spacer()
                Spacer().frame(height: 77)
            }
        }
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing: $viewModel.isLoading )

        // Two-way binding so dismissing the alert clears the error
        .errorAlert(
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            ),
            message: viewModel.errorMessage
        )
        .customSheet(isPresented: $isRescheduling) {
            ReSchedualView(isPresentingNewMeasurementSheet: $isRescheduling, reschedualcase: .reschedualSession)
        }
        .task {
            await viewModel.load()
            if Helper.shared.CheckIfLoggedIn() {
                await profileViewModel.getProfile()
            } else {
                profileViewModel.cleanup()
            }
        }
        // Navigate on selection and reset so selecting the same item again works
        .onChange(of: selectedPackage) { newValue in
            guard let selected = newValue else { return }
            router.push(PackageDetailsView(package: selected))
            // reset selection after navigation
            selectedPackage = nil
        }
        .refreshable {
            await viewModel.load()
        }
    }
}

#Preview {
    NewTabView()
        .environmentObject(EditProfileViewModel.shared)
        .environmentObject(NavigationRouter.shared)
}

// MARK: - Generic Equatable wrapper by value
// This avoids requiring the wrapped view to conform to Equatable.
struct EquatableByValue<Value: Equatable, Content: View>: View, Equatable {
    let value: Value
    let content: () -> Content

    init(value: Value, @ViewBuilder content: @escaping () -> Content) {
        self.value = value
        self.content = content
    }

    static func == (lhs: EquatableByValue<Value, Content>, rhs: EquatableByValue<Value, Content>) -> Bool {
        lhs.value == rhs.value
    }

    var body: some View {
        content()
    }
}
