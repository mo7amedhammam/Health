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

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    AvailableDoctorsListView(
                        doctors: viewModel.availableDoctors,
                        action: { doctor in
                            viewModel.selectDoctor(doctor)
                        }
                    )
                }
                .padding([.horizontal, .top], 10)

                Spacer().frame(height: 55)
            }
        }
        .edgesIgnoringSafeArea([.top, .horizontal])
        .task {
            await viewModel.loadOnce()
        }
        .localizeView()
        .showHud(isShowing: $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
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
                            (Text(" \(package.doctorCount ?? 0) ") + Text("avilable_doc".localized))
                                .font(.regular(size: 10))

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
                        .font(.semiBold(size: 12))

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
                    .font(.semiBold(size: 16))
                Text("sessions".localized)
            }
            .font(.regular(size: 10))
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

    var body: some View {
        VStack {
            ScrollView {
                ForEach(doctors, id: \.self) { item in
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

                            Text("job title" + " - " + "uiniverrsity name")
                                .font(.medium(size: 10))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color(.secondary))
                                .padding(.bottom, 2)

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
                }
                .padding(10)
            }
            .padding(-10)
        }
        .padding(.bottom, 5)
    }
}

struct DiscountLine: View {
    let discount: Double?
    var body: some View {
        HStack(spacing: 0) {
            Text("(".localized)
            Text("Discount".localized + " ")
            Text(discount ?? 0, format: .percent)
            Text(")".localized)
        }
        .font(.semiBold(size: 12))
        .foregroundStyle(Color.white)
    }
}
