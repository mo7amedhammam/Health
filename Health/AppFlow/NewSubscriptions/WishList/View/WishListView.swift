//
//  WishListView.swift
//  Sehaty
//
//  Created by mohamed hammam on 11/06/2025.
//

import SwiftUI

struct WishListView: View {
    @StateObject var viewModel: WishListViewModel = WishListViewModel.shared

    var body: some View {
        VStack( spacing: 0){
            TitleBar(title: "favorite_packages",hasbackBtn: true)
            
            PackagesListView(packaces: viewModel.WishList)
                .refreshable {
                    await viewModel.getWishList()
                }
            
        }
        .task{
            await viewModel.getWishList()
        }
        .localizeView()
        .showHud(isShowing:  $viewModel.isLoading)
        .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)

    }
}

#Preview {
    WishListView()
}
