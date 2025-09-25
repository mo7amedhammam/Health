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
    @State private var isReschedualling: Bool = false

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

    private var mostViewedState: PackagesListViewState {
        let items = viewModel.mostViewedPackages ?? []
        return PackagesListViewState(fingerprints: items.map(fingerprint(for:)))
    }

    private var measurementsState: MeasurementsViewState {
        let items = viewModel.myMeasurements ?? []
        return MeasurementsViewState(fingerprints: items.map(fingerprint(for:)))
    }

    init() {
        _viewModel = StateObject(wrappedValue: NewHomeViewModel())
    }

    var body: some View {
        VStack {
            TitleBar(title: "home_navtitle")

            ScrollView(showsIndicators: false) {
                HeaderView()
                    .environmentObject(profileViewModel)
                    .padding(.horizontal)

                VStack(alignment: .leading) {
                    if let nextsession = viewModel.upcomingSession {
                        NextSessionSection(
                            upcomingSession: nextsession,
                            detailsAction: {},
                            rescheduleAction: { isReschedualling = true }
                        )
                        .padding(.horizontal)
                    }

                    MainCategoriesSection(categories: viewModel.homeCategories) { category in
                        router.push(PackagesView(mainCategory: category))
                    }

                    Image(.adsbg)
                        .resizable()
                        .frame(height: 137)
                        .padding(.horizontal)

                    // Last measurements wrapped with EquatableByValue
                    EquatableByValue(value: measurementsState) {
                        LastMesurmentsSection(measurements: viewModel.myMeasurements) { item in
                            guard let item = item else { return }
                            router.push(MeasurementDetailsView(stat: item))
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
                    }

                    Image(.adsbg2)
                        .resizable()
                        .frame(height: 229)
                        .padding(.horizontal)

                    // Most viewed/booked wrapped with EquatableByValue
                    EquatableByValue(value: mostViewedState) {
                        MostViewedBooked(
                            packaces: viewModel.mostViewedPackages,
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
                                Task {
                                    await viewModel.getMostBookedOrViewedPackages(
                                        forcase: newTab == .mostviewed ? .MostViewed : .MostBooked
                                    )
                                }
                            }
                        )
                    }
                }

                Spacer()
                Spacer().frame(height: 77)
            }
        }
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing: $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
        .customSheet(isPresented: $isReschedualling) {
            ReSchedualView(isPresentingNewMeasurementSheet: $isReschedualling, reschedualcase: .reschedualSession)
        }
        .task {
            await viewModel.load()
            if Helper.shared.CheckIfLoggedIn() {
                await profileViewModel.getProfile()
            } else {
                profileViewModel.cleanup()
            }
        }
        .task(id: selectedPackage) {
            guard let selectedPackage = selectedPackage else { return }
            router.push(PackageDetailsView(package: selectedPackage))
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

    static func == (lhs: EquatableByValue<Value, Content>, rhs: EquatableByValue<Value, Content>) -> Bool {
        lhs.value == rhs.value
    }

    var body: some View {
        content()
    }
}
