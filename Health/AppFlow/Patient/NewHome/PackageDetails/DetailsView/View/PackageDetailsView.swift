//
//  PackageDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

struct PackageDetailsView: View {
    @StateObject private var viewModel: AvailableDoctorsViewModel

    init(package: FeaturedPackageItemM) {
        _viewModel = StateObject(wrappedValue: AvailableDoctorsViewModel(package: package))
    }

    var body: some View {
        VStack(spacing: 0) {
            headerSection(package: viewModel.package)

            pricingBar(package: viewModel.package)

            Spacer()
            
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading) {
            if let doctors = viewModel.availableDoctors?.items{
                        AvailableDoctorsListView(
                            doctors: doctors,
                            action: { doctor in
                                viewModel.selectDoctor(doctor)
                            },
                            isLoading: viewModel.isLoading ?? false,
                            canLoadMore: viewModel.canLoadMore ?? false,
                            loadMore: {
//                                guard viewModel.canLoadMore == true else { return }
                                Task {await viewModel.loadMoreDoctorsIfNeeded()}
                            }
                        )
//                    }
//                }

                Spacer().frame(height: 55)
            }
        }
        .edgesIgnoringSafeArea([.top, .horizontal])
        .task {
            await viewModel.getAvailableDoctors()
        }
        .refreshable {
            await viewModel.refresh()
        }
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading)
        .errorAlert(isPresented:Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        ), message: viewModel.errorMessage)
        // Navigation without AnyView/type-erasure; minimal invalidations
        .background(
            NavigationLink(
                "",
                destination: Group {
                    if let id = viewModel.selectedDoctorPackageId {
                        PackageMoreDetailsView(doctorPackageId: id)
                    } else {
                        EmptyView()
                    }
                },
                isActive: Binding(
                    get: { viewModel.selectedDoctorPackageId != nil },
                    set: { active in
                        if !active { viewModel.clearSelection() }
                    }
                )
            )
            .hidden()
        )
    }

    // MARK: - Subviews

    @ViewBuilder
    private func headerSection(package: FeaturedPackageItemM) -> some View {
        VStack {
            VStack {
                TitleBar(title: "", hasbackBtn: true)
                    .padding(.top, 50)

                Spacer()

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(package.name ?? "pack_name".localized)
                            .font(.semiBold(size: 22))
                            .foregroundStyle(.white)

                        Text(package.mainCategoryName ?? "seha 3ama")
                            .padding(.top, 4)

                        Text(package.categoryName ?? "tagzia 3lagia")
                    }
                    .font(.medium(size: 18))
                    .foregroundStyle(Color.white)

                    Spacer()

                    VStack(alignment: .trailing) {
                        Button(action: {}) {
                            Image(.newlikeicon)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        Spacer()

                        HStack(alignment: .center, spacing: 5) {
                            (Text(" \(package.doctorCount ?? 0) ").font(.bold(size: 14)) + Text("available_doc".localized))
                                .font(.regular(size: 12))

                            Image(.newdocicon)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 10, height: 12)
                                .scaledToFit()
                                .foregroundStyle(Color("FF8F15"))
                                .padding(3)
                        }
                        .font(.medium(size: 12))
                        .foregroundStyle(Color.white)
                    }
                }
                .frame(height: 76)
                .padding(10)
                .background {
                    BlurView(radius: 5)
                        .horizontalGradientBackground().opacity(0.89)
                }
            }
            .background {
                KFImageLoader(
                    url: URL(string: Constants.imagesURL + (package.imagePath?.validateSlashs() ?? "")),
                    placeholder: Image("logo"),
                    shouldRefetch: true
                )
                .frame(height: 195)
            }
            .frame(height: 239)
        }
    }

    @ViewBuilder
    private func pricingBar(package: FeaturedPackageItemM) -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                (Text(package.priceAfterDiscount ?? 0, format: .number.precision(.fractionLength(1))) + Text(" " + "EGP".localized))
                    .font(.semiBold(size: 16))
                    .foregroundStyle(Color.white)

                HStack {
                    (Text(package.priceBeforeDiscount ?? 0, format: .number.precision(.fractionLength(1))) + Text(" " + "EGP".localized))
                        .strikethrough()
                        .foregroundStyle(Color(.secondary))
                        .font(.medium(size: 12))

                    DiscountLine(discount: package.discount)
                }
                .padding(.top, 2)
            }

            Spacer()

            HStack(spacing: 3) {
                Image(.newconversationicon)
                    .resizable()
                    .frame(width: 16, height: 9)
                Text("\(package.sessionCount ?? 0) ")
                    .font(.semiBold(size: 18))
                Text("sessions".localized)
            }
            .font(.regular(size: 12))
            .foregroundStyle(Color.white)
            .frame(height: 32)
            .padding(.horizontal, 10)
            .background { Color(.secondaryMain) }
            .cardStyle(cornerRadius: 3)
        }
        .padding()
        .frame(height: 69)
        .background(Color.mainBlue)
    }
}

#Preview {
    PackageDetailsView(package: .init())
}

struct AvailableDoctorsListView: View {
    let doctors: [AvailabeDoctorsItemM]
    var action: ((AvailabeDoctorsItemM) -> Void)?
    var isLoading: Bool
    var canLoadMore: Bool
    var loadMore: (() -> Void)?
    
    // Stable identifier for ForEach to help the compiler
    private func stableID(for item: AvailabeDoctorsItemM) -> Int {
        if let id = item.packageDoctorID { return id }
        let doctor = item.id ?? -1
        let specHash = item.speciality?.hashValue ?? 0
        // Combine bits in a cheap, deterministic way
        return (doctor &* 31) &+ specHash
    }
    
    private var uniqueDoctors: [AvailabeDoctorsItemM] {
        // Prefer unique by packageDoctorID; if nil, fall back to unique by doctorId + speciality concatenation
        var seen = Set<Int>()
        var result: [AvailabeDoctorsItemM] = []
        for doc in doctors {
            if let id = doc.packageDoctorID {
                if !seen.contains(id) {
                    seen.insert(id)
                    result.append(doc)
                }
            } else {
                // If no packageDoctorID, allow through (could also add a secondary de-dupe if needed)
                result.append(doc)
            }
        }
        return result
    }

    init(doctors: [AvailabeDoctorsItemM], action: ((AvailabeDoctorsItemM) -> Void)? = nil,isLoading: Bool, canLoadMore: Bool, loadMore: (() -> Void)? = nil) {
        self.doctors = doctors
        self.action = action
        self.isLoading = isLoading
        self.canLoadMore = canLoadMore
        self.loadMore = loadMore
    }
    var body: some View {
        ScrollView {
        LazyVStack {
                let itemsWithIDs = uniqueDoctors.map { (stableID(for: $0), $0) }
                ForEach(itemsWithIDs, id: \.0) { pair in
                    let item = pair.1
                    Button(action: { action?(item) }) {
                        VStack {
                            KFImageLoader(
                                url: URL(string: Constants.imagesURL + (item.doctorImage?.validateSlashs() ?? "")),
                                placeholder: Image("logo"),
                                shouldRefetch: true
                            )
                            .frame(height: 160)
                            .frame(maxWidth: .infinity)
                            .cardStyle(cornerRadius: 3, shadowOpacity: 0.1)

                            HStack(alignment: .center, spacing: 5) {
                                Text(item.doctorName ?? "name")
                                    .font(.semiBold(size: 22))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(Color.mainBlue)

                                HStack(spacing: 2) {
                                    Text(item.speciality ?? "")
                                        .font(.semiBold(size: 12))
                                        .foregroundStyle(Color.mainBlue)

                                    Image(.newpharmacisticon)
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .scaledToFit()
                                        .padding(3)
                                }
                            }

//                            Text("job title" + " - " + "uiniverrsity name")
//                                .font(.semiBold(size: 14))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .foregroundStyle(Color(.secondary))
//                                .padding(.bottom, 2)

                            HStack(spacing: 5) {
                                Image(.newmoreicon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 15, height: 15)

                                Text("more_detail".localized)
                            }
                            .font(.bold(size: 16))
                            .foregroundStyle(Color.white)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 10)
                            .horizontalGradientBackground()
                            .cornerRadius(3)
                            .contentShape(Rectangle())
                        }
                    }
                    .background { Color.white }
                    .padding(10)
                    .cardStyle(cornerRadius: 3)
                    .onAppear {
                        guard pair.1 == doctors.last else { return }
                        guard canLoadMore, !isLoading else { return }
                        loadMore?()
                    }
                }
                .padding(.horizontal,10)
            }
            .padding([.top], 10)
        }
        .padding(.bottom, 5)

    }
}

struct DiscountLine: View {
    let discount: Double?
    private var percentFraction: Double {
          let value = discount ?? 0
          // If the caller passed whole percent (e.g. 20) convert to fraction 0.2
          return value > 1 ? value / 100.0 : value
      }
    
    var body: some View {
        HStack(spacing: 0) {
            Text("(".localized)
            Text("Discount".localized + " ")
            Text(percentFraction , format: .percent)
            Text(")".localized)
        }
        .font(.semiBold(size: 12))
        .foregroundStyle(Color.white)
    }
}

