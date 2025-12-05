//
//  SelectLanguageView.swift
//  Sehaty
//
//  Created by mohamed hammam on 05/04/2025.
//

import SwiftUI

struct SelectLanguageView : View {
    @Environment(\.dismiss) var dismiss
    @StateObject var localizationManager = LocalizationManager.shared
    @StateObject private var lookupsVM = LookupsViewModel.shared
    @State private var selectedCountry:AppCountryM?
//    = .init(id: 1, name: "Egypt", flag: "🇪🇬")
    @State private var selectedLanguage:LanguageM?
//    = .init(id: 1, lang1: "Arabic", flag: "🇪🇬")
    @State private var isLoading:Bool? = false

    // Bottom sheet controls
    @State private var showLanguageSheet = false
    @State private var showCountrySheet = false

    // Temporary selections while the sheet is open
    @State private var tempLanguage: LanguageM?
    @State private var tempCountry: AppCountryM?

    var hasbackBtn:Bool = false

    fileprivate func LoadData() async {
        isLoading = true
        defer { isLoading = false }
        async let countries:() = await lookupsVM.getAppCountries()
        async let languages:() = await lookupsVM.getLanguages()
        
        _ = await (countries,languages)
        
        if let countries = lookupsVM.appCountries ,let savedCountryId = Helper.shared.AppCountryId() {
            selectedCountry = countries.first(where: { $0.id == savedCountryId }) ?? countries.first
        }
        if let languages = lookupsVM.languages {
            selectedLanguage = languages.first(where: { $0.lang1?.lowercased() == localizationManager.currentLanguage.lowercased() }) ?? languages.first
        }
    }
    
    var body: some View {
        VStack{
            TitleBar(title: "lang_Title".localized,hasbackBtn: hasbackBtn)
            
            Spacer()
            
            VStack(spacing:10){
                Image(.languageicon)
                
                Text("lang_Subtitle".localized)
                    .frame(maxWidth:.infinity)
                    .multilineTextAlignment(.center)
                    .font(.semiBold(size: 22))
                    .foregroundStyle(Color(.wrong))
                    .padding(.top,40)
                    .padding(.bottom,20)
                
                VStack(spacing:20){
                    
                    // Tappable field opens language bottom sheet
                    CustomDropListInputFieldUI(
                        title: "lang_Language_title",
                        placeholder: "lang_Language_subtitle",
                        text: .constant(selectedLanguage?.lang1 ?? ""),
                        isValid: true,
                        isDisabled: true,
                        showDropdownIndicator:true,
                        trailingView: AnyView(
                            KFImageLoader(url:URL(string:Constants.imagesURL + (selectedLanguage?.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                .frame(width: 30,height:20)
                        )
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tempLanguage = selectedLanguage
                        showLanguageSheet = true
                    }
                    
                    // Tappable field opens country bottom sheet
                    CustomDropListInputFieldUI(
                        title: "lang_Country_title",
                        placeholder: "lang_Country_subitle",
                        text: .constant(selectedCountry?.name ?? ""),
                        isValid: true,
                        isDisabled: true,
                        showDropdownIndicator:true,
                        trailingView: AnyView(
                            KFImageLoader(url:URL(string:Constants.imagesURL + (selectedCountry?.flag?.validateSlashs() ?? "")),placeholder: Image("egFlagIcon"), shouldRefetch: true)
                                .frame(width: 30,height:20)
                        )
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tempCountry = selectedCountry
                        showCountrySheet = true
                    }
                }
                .padding(.top,10)
            }
            .padding(.horizontal)
            
            Spacer()

            CustomButton(title: "lang_Ok_Btn",isdisabled:
                            LocalizationManager.shared.currentLanguage.isEmpty || selectedCountry == nil
                         ,backgroundView:AnyView(Color.clear.horizontalGradientBackground())){
                
                Task{ await setLanguage(selectedLanguage?.lang1?.lowercased() ?? Helper.shared.getLanguage()) }
                
                if !Helper.shared.CheckIfLoggedIn() && !Helper.shared.checkOnBoard(){
                    let rootVC = UIHostingController(rootView: OnboardingView())
                    rootVC.navigationController?.isNavigationBarHidden = true
                    rootVC.navigationController?.toolbar.isHidden = true
                    Helper.shared.changeRootVC(newroot: rootVC, transitionFrom: .fromRight)
                }else{
                    let rootVC = UIHostingController(rootView: NewTabView(selectedTab: 0))
                    rootVC.navigationController?.isNavigationBarHidden = true
                    rootVC.navigationController?.toolbar.isHidden = true
                    Helper.shared.changeRootVC(newroot: rootVC, transitionFrom: .fromRight)
                }
            }
        }
        .localizeView()
        .showHud(isShowing: $isLoading)
        .onAppear() {
            Task{
                await LoadData()
            }
        }
        // Language bottom sheet using customSheet with tap-to-select list (no Picker)
        .customSheet(isPresented: $showLanguageSheet, height: 250) {
            BottomListSheet(
                title: "lang_Language_title".localized,
                selection: Binding<LanguageM?>(
                    get: { tempLanguage },
                    set: { tempLanguage = $0 }
                ),
                data: lookupsVM.languages ?? [],
                rowHeight: 55
            ) { language, isSelected in
                HStack {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(.secondaryMain))
                    }
                    Text(language.lang1 ?? "")
                        .font(.semiBold(size: 18))
                        .foregroundStyle(isSelected ? Color(.mainBlue) : Color(.main))
                    Spacer()
                    KFImageLoader(
                        url: URL(string: Constants.imagesURL + (language.flag?.validateSlashs() ?? "")),
                        placeholder: Image("egFlagIcon"),
                        shouldRefetch: true
                    )
                    .frame(width: 30, height: 20)
                }
                .padding(.horizontal)
                .frame(height: 55)
                .contentShape(Rectangle())
            } onTapRow: { tapped in
                tempLanguage = tapped
            } onDone: {
                selectedLanguage = tempLanguage
                if let code = selectedLanguage?.lang1 {
                    Task { await setLanguage(code) }
                }
                showLanguageSheet = false
            } onCancel: {
                showLanguageSheet = false
            }
        }
        // Country bottom sheet using customSheet with tap-to-select list (no Picker)
        .customSheet(isPresented: $showCountrySheet, height: 250) {
            BottomListSheet(
                title: "lang_Country_title".localized,
                selection: Binding<AppCountryM?>(
                    get: { tempCountry },
                    set: { tempCountry = $0 }
                ),
                data: lookupsVM.appCountries ?? [],
                rowHeight: 55
            ) { country, isSelected in
                HStack {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(.secondaryMain))
                    }
                    Text(country.name ?? "")
                        .font(.semiBold(size: 18))
                        .foregroundStyle(isSelected ? Color(.mainBlue) : Color(.main))
                    Spacer()
                    KFImageLoader(
                        url: URL(string: Constants.imagesURL + (country.flag?.validateSlashs() ?? "")),
                        placeholder: Image("egFlagIcon"),
                        shouldRefetch: true
                    )
                    .frame(width: 30, height: 20)
                }
                .padding(.horizontal)
                .frame(height: 55)
                .contentShape(Rectangle())
            } onTapRow: { tapped in
                tempCountry = tapped
            } onDone: {
                selectedCountry = tempCountry
                if let id = selectedCountry?.id {
                    Helper.shared.AppCountryId(Id: id)
                }
                showCountrySheet = false
            } onCancel: {
                showCountrySheet = false
            }
        }
    }
    
    private func setLanguage(_ language: String) async {
        Helper.shared.languageSelected(opened: true)
        LocalizationManager.shared.changeLanguage(to: language) {
        }
        Helper.shared.AppCountryId(Id: selectedCountry?.id)
       
        await LoadData()
     }
}

// MARK: - BottomListSheet (no Picker, tap to select)
private struct BottomListSheet<Item: Hashable>: View {
    let title: String
    @Binding var selection: Item?
    let data: [Item]
    let rowHeight: CGFloat
    let rowContent: (Item, Bool) -> AnyView
    let onTapRow: (Item) -> Void
    let onDone: () -> Void
    let onCancel: () -> Void
    
    init(
        title: String,
        selection: Binding<Item?>,
        data: [Item],
        rowHeight: CGFloat = 55,
        @ViewBuilder rowContent: @escaping (Item, Bool) -> some View,
        onTapRow: @escaping (Item) -> Void,
        onDone: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self._selection = selection
        self.data = data
        self.rowHeight = rowHeight
        self.rowContent = { item, isSel in AnyView(rowContent(item, isSel)) }
        self.onTapRow = onTapRow
        self.onDone = onDone
        self.onCancel = onCancel
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: onCancel) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.pink)
                }
                Spacer()
                Text(title)
                    .font(.semiBold(size: 18))
                    .foregroundStyle(Color(.main))
                Spacer()
                Button("Done_".localized, action: onDone)
                    .font(.semiBold(size: 16))
                    .foregroundStyle(Color(.mainBlue))
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(data), id: \.self) { item in
                        Button {
                            onTapRow(item)
                        } label: {
                            rowContent(item, selection == item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                        Divider()
                            .padding(.leading)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .localizeView()
    }
}

#Preview {
    SelectLanguageView()
}
