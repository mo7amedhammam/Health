//
//  NewHomeView.swift
//  Sehaty
//
//  Created by mohamed hammam on 13/04/2025.
//

import SwiftUI

struct NewHomeView: View {
    @StateObject private var viewModel = NewHomeViewModel.shared
    @EnvironmentObject var profileViewModel: EditProfileViewModel

    @State private var refreshTask: Task<Void, Never>?
    @StateObject var wishlistviewModel: WishListManagerViewModel = WishListManagerViewModel.shared

    @State var selectedPackage : FeaturedPackageItemM?

    init() {
    }
    
    @State var destination = AnyView(EmptyView())
    @State var isactive: Bool = false
    func pushTo(destination: any View) {
        self.destination = AnyView(destination)
        self.isactive = true
    }
    
    var body: some View {
//        NavigationView(){
            VStack{
                TitleBar(title: "home_navtitle")
                
                ScrollView(showsIndicators: false){
                    HeaderView()
                        .environmentObject(profileViewModel)
                        .padding(.horizontal)

                    VStack(alignment:.leading){
//                        Group{
                            if let nextsession = viewModel.upcomingSession{
                                NextSessionSection(upcomingSession: nextsession)
                                    .padding(.horizontal)
                            }
//                        }
//                        .task {
//                            await viewModel.getUpcomingSession()
//                        }
                        MainCategoriesSection(categories: viewModel.homeCategories){category in
                            pushTo(destination: PackagesView(mainCategory: category))
                        }
//                            .task {
//                                await viewModel.getHomeCategories()
//                            }
                        
                        Image(.adsbg)
                            .resizable()
                            .frame(height: 137)
                            .padding(.horizontal)

                        LastMesurmentsSection(measurements: viewModel.myMeasurements)
//                            .task {
//                                await viewModel.getMyMeasurements()
//                            }
//                            .onAppear(perform: {
//                                Task{
//                                    await viewModel.getMyMeasurements()
//                                }
//                            })
                        
                        VipPackagesSection(packages: viewModel.featuredPackages?.items,selectedPackage: $selectedPackage){packageId in
//                            add to wishlist
                            // Update the source-of-truth array in viewModel
                             if let index = viewModel.featuredPackages?.items?.firstIndex(where: { $0.id == packageId }) {
                                 viewModel.featuredPackages?.items?[index].isWishlist?.toggle()
                             }
                            
                            Task{
                                await wishlistviewModel.addOrRemovePackageToWishList(packageId: packageId)
                            }
                        }
//                        .environmentObject(wishlistviewModel)
//                        .task {
//                            await viewModel.getFeaturedPackages()
//
//                        }
//                        .onAppear(perform: {
//                            Task{
//                                await viewModel.getFeaturedPackages()
//                            }
//                        })
                        
                        Image(.adsbg2)
                            .resizable()
                            .frame(height: 229)
                            .padding(.horizontal)
                        
                        MostViewedBooked(packaces:viewModel.mostViewedPackages,  selectedPackage: $selectedPackage,likeAction: {packageId in
                            //                            add to wishlist
                        },onChangeTab:{ newTab in
//                                             currentCase = newTab
                                             Task {
                                                 await viewModel.getMostBookedOrViewedPackages(forcase: newTab == .mostviewed ? .MostViewed : .MostBooked)
//                                                 packages = newTab == .mostviewed ? viewModel.mostViewedPackages : viewModel.mostBookedPackages
                                             }
                                         })
                            .environmentObject(viewModel)
//                            .onAppear(perform: {
//                                Task{
//                                    await viewModel.getFeaturedPackages()
//                                }
//                            })
//                            .task {
//                                await viewModel.getFeaturedPackages()
//                            }
                    }
                    
                    Spacer()
                    
                    Spacer().frame(height: 77)
                    
                }
                //                .padding(.horizontal)
            }
//            .reversLocalizeView()
            .localizeView()
            .showHud(isShowing:  $viewModel.isLoading)
            .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

            .onAppear{
                selectedPackage = nil
            }
            .task {
                await viewModel.refresh()
            }
            .task(id: selectedPackage){
                guard let selectedPackage = selectedPackage else { return }
                pushTo(destination: PackageDetailsView(package: selectedPackage))
            }
            .refreshable {
                await viewModel.refresh()
            }
            .onDisappear {
                refreshTask?.cancel()
            }
        
        NavigationLink( "", destination: destination, isActive: $isactive)
        
    }
    
}

#Preview {
    //    NewHomeView()
    NewTabView()
}












