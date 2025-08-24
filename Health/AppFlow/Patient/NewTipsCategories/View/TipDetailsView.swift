//
//  TipDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 12/07/2025.
//

import SwiftUI
import WebKit

struct TipDetailsView: View {
    let tipId: Int?
    @EnvironmentObject private var viewModel : TipDetailsViewModel
//    let tip: TipDetailsM?
    @Environment(\.dismiss) var dismiss

    var body: some View {
            VStack(spacing: 16) {
                
                    ZStack(alignment: .top){
                        if let imageName = viewModel.tipDetails?.image {
                            KFImageLoader(url:URL(string:Constants.imagesURL + (imageName.validateSlashs())),placeholder: Image("sehatylogobg"), isOpenable: false,shouldRefetch: false)
                            //                            .resizable()
                            //                        .clipShape(Circle())
                            //                            .frame( height: 280)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 300)
                            //                        .frame(width: 160, height: 160)
                                .cardStyle(cornerRadius: 3)
                        }
                        TitleBar(title: "",hasbackBtn: true)
                            .padding(.top,55)
                    }
                    
                if let tip = viewModel.tipDetails {
                    ScrollView {
                        // Title & Meta Info
                        VStack(alignment: .leading, spacing: 20) {
                            Text(tip.title ?? "")
                                .font(.semiBold(size: 24))
                                .foregroundColor(.mainBlue)
                            
                            HStack(spacing: 2) {
                                Text("categ_".localized)
                                    .font(.regular(size: 14))
                                    .foregroundColor(Color(.secondary))
                                
                                Text(tip.tipCategoryTitle ?? "")
                                    .font(.regular(size: 14))
                                    .foregroundColor(.mainBlue)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                
                                Text(tip.formattedDate ?? "")
                                    .font(.regular(size: 10))
                                    .foregroundColor(.mainBlue)
                            }
                        }
                        
                        // HTML Description
                        if let html = tip.description {
                            HTMLTextView(html: html)
                                .frame(minHeight: 300)
                                .padding(.top)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .localizeView()
            .edgesIgnoringSafeArea(.top)
            .showHud(isShowing:  $viewModel.isLoading)
            .errorAlert(isPresented: .constant(viewModel.errorMessage != nil), message: viewModel.errorMessage)
            .task {
                Task{
                    viewModel.tipId = tipId
                    await viewModel.GetTipDetails()
                }
            }
            .onDisappear(){
                viewModel.tipDetails = nil
            }
        
//        }
        .background(Color(.bgPink).ignoresSafeArea())
    }
}
#Preview {
    TipDetailsView(tipId: 2)
        .environmentObject(TipDetailsViewModel.shared)
//    TipDetailsView(tip: TipDetailsM(
//        id: 204,
//        title: "التحكم في مرض السكري",
//        description: """
//        <p>التحكم في مرض السكري يبدأ من تنظيم أسلوب الحياة وتناول الغذاء الصحي.</p>
//        <ul>
//            <li>ممارسة النشاط البدني بانتظام.</li>
//            <li>تقليل السكريات والدهون في الوجبات.</li>
//            <li>الالتزام بالأدوية الموصوفة.</li>
//        </ul>
//        """,
//        date: "2024-01-01T17:00:00",
//        tipCategoryID: 3,
//        image: "Images\\Tip\\18df1be8-3802-4dfa-b5c2-59751c45ab03.jpg",
//        tipCategoryTitle: "التحكم في مرض السكري",
//        views: 26,
//        drugGroups: [
//            DrugGroup(id: 3, order: nil, title: "أدوية السكر"),
//            DrugGroup(id: 87, order: nil, title: "أدوية فقدان الوزن(Weight Loss Agent)"),
//            DrugGroup(id: 106, order: nil, title: "أدوية التخسيس"),
//            DrugGroup(id: 101, order: nil, title: "انزيم(Enzyme)")
//        ]
//    ))
}


struct HTMLTextView: UIViewRepresentable {
    var html: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let htmlStart = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        body {
            font-family: '\(fontsenum.regular.rawValue)', -apple-system, BlinkMacSystemFont, sans-serif;
            font-size: 14px;
            color: #007BBD;
            direction: rtl;
            text-align: right;
            padding: 0;
            margin: 0;
        }
        ul { padding-inline-start: 20px; }
        </style>
        </head>
        <body>
        """
        let htmlEnd = "</body></html>"
        let fullHTML = htmlStart + html + htmlEnd
        uiView.loadHTMLString(fullHTML, baseURL: nil)
    }
}
