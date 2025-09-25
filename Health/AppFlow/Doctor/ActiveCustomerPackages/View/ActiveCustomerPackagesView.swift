//
//  ActiveCustomerPackagesView.swift
//  Sehaty
//
//  Created by mohamed hammam on 31/08/2025.
//
import SwiftUI

struct ActiveCustomerPackagesView: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var viewModel: ActiveCusPackViewModel

    let customerPackageId: Int

    @State private var selectedSection: SectionType = .sessions
    @State private var reschedualcase: reschedualCases? = .reschedualSession
    @State private var isReschedualling: Bool = false

    @State private var showCancel: Bool = false
    @State private var idToCancel: Int?

    enum SectionType: CaseIterable, Hashable {
        case chats, sessions, files

        var title: String {
            switch self {
            case .chats: return "Chats_"
            case .sessions: return "sessions_"
            case .files: return "Files_"
            }
        }

        var image: Image {
            switch self {
            case .chats: return Image(.chats)
            case .sessions: return Image(.sessions)
            case .files: return Image(.packagefiles)
            }
        }
    }

    init(package: SubcripedPackageItemM? = nil, CustomerPackageId: Int) {
        self.customerPackageId = CustomerPackageId
        _viewModel = StateObject(wrappedValue: ActiveCusPackViewModel())
        // If you want to seed initial UI instantly:
        // _viewModel = StateObject(wrappedValue: ActiveCusPackViewModel(initialPackage: package))
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                TitleBar(title: "",hasbackBtn: true)
                    .padding(.top, 50)

                Spacer()

                ZStack(alignment: .top) {
                    HStack {
                        VStack {
                            Text(viewModel.subscripedPackage?.packageName ?? "pack_Name".localized)
                                .font(.semiBold(size: 20))
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack {
                                Text(viewModel.subscripedPackage?.mainCategoryName ?? "main_category")
                                Circle()
                                    .fill(Color(.secondary))
                                    .frame(width: 5, height: 5)

                                Text(viewModel.subscripedPackage?.categoryName ?? "sub_category")
                            }
                            .font(.medium(size: 14))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        VStack(alignment: .trailing, spacing: 5) {
                            HStack(spacing: 3) {
                                Circle()
                                    .frame(width: 5, height: 5)
                                Text(viewModel.subscripedPackage?.status ?? "Active")
                            }
                            .font(.medium(size: 10))
                            .foregroundStyle(Color.white)
                            .frame(height: 22)
                            .padding(.horizontal, 10)
                            .background { Color(viewModel.subscripedPackage?.canCancel ?? false ? .active : .notActive) }
                            .cardStyle(cornerRadius: 3)

                            HStack(spacing: 0) {
                                Text("remain_".localized)

                                (Text(" \(viewModel.subscripedPackage?.remainingSessionCount ?? 0) " + "from_".localized + " \(viewModel.subscripedPackage?.sessionCount ?? 0) "))
                                    .font(.bold(size: 12))

                                Text("sessions_ar".localized)

                                Image("remainingsessions")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 9, height: 9)
                                    .padding(.horizontal, 3)
                                    .foregroundStyle(.white)
                            }
                            .font(.regular(size: 12))
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(Color(.white))
                            .padding(.vertical, 8)
                        }
                        .font(.regular(size: 10))
                        .foregroundStyle(Color.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background {
                        BlurView(radius: 5)
                            .horizontalGradientBackground().opacity(0.89)
                    }
                }
            }
            .background {
                KFImageLoader(
                    url: URL(string: Constants.imagesURL + (viewModel.subscripedPackage?.packageImage?.validateSlashs() ?? "")),
                    placeholder: Image("logo"),
                    shouldRefetch: true
                )
                .frame(height: 238)
            }
            .frame(height: 238)

            ScrollView(showsIndicators: false) {

                HStack {
                    ForEach(SectionType.allCases, id: \.self) { button in
                        Spacer()
                        Button(action: {
                            selectedSection = button
                            switch button {
                            case .chats:
                                guard let customerPackageID = viewModel.subscripedPackage?.customerPackageID else { return }
                                router.push( ChatsView(CustomerPackageId: customerPackageID) )
                            case .sessions:
                                break
                            case .files:
                                guard let customerID = viewModel.subscripedPackage?.customerID,
                                      let packageId = viewModel.subscripedPackage?.customerPackageID else { return }
                                router.push( ActiveCustPackFiles(customerId: customerID,PackageId: packageId) )
                            }
                        }) {
                            VStack(spacing: 7) {
                                button.image
                                    .resizable()
                                    .padding(15)
                                    .background(selectedSection == button ? Color(.secondary):Color(.btnDisabledTxt))
                                    .frame(width: 70,height: 70)
                                    .cardStyle(cornerRadius: 3)

                                Text(button.title.localized)
                                    .font(.bold(size: 12))
                                    .foregroundStyle(selectedSection == button ? Color(.secondary):Color(.btnDisabledTxt))
                            }
                        }

                        if button == .chats || button == .sessions {
                            Spacer()
                            Color.gray.opacity(0.2).frame(width: 1, height: 70)
                                .padding(.bottom)
                        } else {
                            Spacer()
                        }
                    }
                }
                .padding(.vertical)

                if let customerName = viewModel.subscripedPackage?.customerName {
                    CustomerHeaderView(
                        name: customerName,
                        imageUrl: viewModel.subscripedPackage?.customerImage ?? "",
                        onSendNotification: {
                            // implement if needed
                        }
                    )
                    .equatable()
                }

                CustomerMesurmentsSection(measurements: viewModel.customerMeasurements){item in
                    guard let item = item else { return }
                    router.push(MeasurementDetailsView(stat: item))
                }

                CustomButton(title: "select_next_session",isdisabled: false,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                    Task{ reschedualcase = .nextSession }
                    isReschedualling = true
                }

                SubcripedNextSession(upcomingSession: viewModel.upcomingSession,rescheduleAction: {
                    Task{ reschedualcase = .reschedualSession }
                    isReschedualling = true
                })
                .padding(.horizontal)

                SubcripedSessionsList(
                    sessions: viewModel.subscripedSessions?.items,
                    loadMore: {
                        Task { await viewModel.loadMoreSessions(customerPackageId: customerPackageId) }
                    }
                )
                .padding(.horizontal)

                Spacer().frame(height: 55)
            }
        }
        .edgesIgnoringSafeArea([.top,.horizontal])
        .localizeView()
        .withNavigation(router: router)
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
        .task(id: customerPackageId) {
            selectedSection = .sessions
            await viewModel.load(customerPackageId: customerPackageId)
        }
        .customSheet(isPresented: $isReschedualling){
            ReSchedualView(
                doctorPackageId: customerPackageId,
                isPresentingNewMeasurementSheet: $isReschedualling,
                reschedualcase: reschedualcase,
                onRescheduleSuccess: {
                    Task {
                        await viewModel.getUpcomingSession()
                        await viewModel.getSubscripedPackageDetails(CustomerPackageId: customerPackageId)
                        await viewModel.getSubscripedPackagesList(customerPackageId: customerPackageId)
                    }
                }
            )
        }
        .overlay(
            Group {
                if showCancel {
                    CancelSubscriptionView(
                        isPresent: $showCancel,
                        customerPackageId: idToCancel ?? 0,
                        onCancelSuccess: {
                            Task {
                                await viewModel.getSubscripedPackageDetails(CustomerPackageId: customerPackageId)
                            }
                        }
                    )
                }
            }
        )
    }
}

#Preview {
    ActiveCustomerPackagesView(CustomerPackageId: 0)
        .environmentObject(NavigationRouter.shared)
}


struct CustomerHeaderView: View, Equatable {
    var name: String
    var imageUrl: String?
    var onSendNotification: (() -> Void)? = nil

    static func == (lhs: CustomerHeaderView, rhs: CustomerHeaderView) -> Bool {
        lhs.name == rhs.name && lhs.imageUrl == rhs.imageUrl
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Profile Image with gradient border
            ZStack {
                Circle()
                    .strokeBorder(
                        LinearGradient(colors: [.mainBlue, Color(.secondary)],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing),
                        lineWidth: 4
                    )
                    .frame(width: 73, height: 73)

                if let imageUrl = imageUrl {
                    KFImageLoader(url:URL(string:Constants.imagesURL + (imageUrl.validateSlashs())),placeholder: Image("logo"), shouldRefetch: true)
                        .frame(width: 66, height: 66)
                        .clipShape(Circle())
                } else {
                    Image("placeholder_user")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 66, height: 66)
                }
            }

            // Customer name
            ZStack {
                Image("logoWaterMarkIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 105)
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.bold(size: 24))
                        .foregroundColor(.mainBlue)

                    Button(action: {
                        onSendNotification?()
                    }) {
                        HStack(spacing: 4) {
                            Image("inactivedrugicon")
                                .resizable()
                                .frame(width: 14, height: 14)
                            Text("send_customer_notification".localized)
                                .font(.semiBold(size: 14))
                                .underline()
                        }
                        .foregroundColor(Color(.secondary))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .padding([.vertical,.leading])
    }
}
