//
//  PackageMoreDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

struct PackageMoreDetailsView: View {
    var doctorPackageId: Int
    @StateObject var viewModel = PackageMoreDetailsViewModel.shared
    
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM - yyyy"
//        return formatter.string(from: date)
//    }
    
    init(doctorPackageId: Int) {
        self.doctorPackageId = doctorPackageId
    }

    var body: some View {
//        NavigationView(){
        VStack(spacing:0){
            let doctorData = viewModel.packageDetails?.doctorData
            let packageData = viewModel.packageDetails?.packageData

                VStack(){
                    TitleBar(title: "",hasbackBtn: true)
                        .padding(.top,50)

                    Spacer()
                    
//                    HStack{
                        VStack{
                            (Text("doc".localized + "/".localized) + Text(doctorData?.doctorName ?? "name".localized))
                               .font(.bold(size: 16))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity,alignment:.center)

//                            HStack(alignment: .center,spacing: 5){
//                                Text( "التغذية العلاجية")
//                                Circle().fill(Color(.white))
//                                    .frame(width: 4, height: 4)
//                                Text("صحة عامة")
//                            }
//                            .font(.medium(size: 10))
//                            .foregroundStyle(Color.white)
                            
                            HStack(spacing:2) {
                                Image(.newpharmacisticon)
//                                            .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 12,height:12)
                                    .scaledToFit()
//                                            .foregroundStyle(.white)
                                    .padding(3)
                                
                                Text(doctorData?.speciality ?? "speciality".localized)
                                   .font(.medium(size: 10))
                                   .foregroundStyle(Color.white)
                            }
                        }
                    .padding(10)
                    .background{
                        BlurView(radius: 6)
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    }
                    
                }
                .background{
                    KFImageLoader(url:URL(string:Constants.imagesURL + (doctorData?.doctorImage?.validateSlashs() ?? "")),placeholder: Image("logo"), shouldRefetch: true)
                        .frame( height: 195)

//                    Image(.adsbg2)
//                        .resizable()
                }
                .frame(height: 195)
                
                ScrollView(showsIndicators: false){
                    
                    VStack(alignment:.leading){
                        
                    HStack(alignment: .bottom){
                        
                        VStack(alignment:.leading,spacing: 8){
                            Text("pack_Name".localized + ":")
                                .font(.regular(size: 13))
                                .foregroundStyle(Color.white)

                            Text(packageData?.packageName ?? "pack_Name".localized )
                                   .font(.semiBold(size: 15))
                                    .foregroundStyle(.white)
                                
                                HStack(alignment: .center,spacing: 5){
                                    Text( packageData?.categoryName ?? "category_Name".localized)
                                    Circle().fill(Color(.white))
                                        .frame(width: 4, height: 4)
                                    Text(packageData?.mainCategoryName ?? "صحة عامة")
                                }
                                .font(.medium(size: 10))
                                .foregroundStyle(Color.white)
                                
                            // Title
                            HStack (spacing:0){
                                Image(.newconversationicon)
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 16, height: 9)
                                    .foregroundStyle(Color(.secondaryMain))

                               ( Text(" \(packageData?.sessionCount ?? 0) " )
                                    .font(.semiBold(size: 16)) + Text( "sessions".localized)
                                    .font(.regular(size: 10)))
                                
                                Text(" - " + "sessions_Duration".localized)
                                    .font(.regular(size: 10))

                                Text(" \(packageData?.duration ?? 0) " + "Minute_".localized)
                                    .font(.regular(size: 10))
                                
                            }
//                            .font(.regular(size: 10))
                            .foregroundStyle(Color.white)
//                            .frame(height:32)
//                            .padding(.horizontal,10)
//                            .background{Color(.secondaryMain)}
//                            .cardStyle( cornerRadius: 3)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center,spacing: 4){
                            Group{
                                Text("\(packageData?.priceAfterDiscount ?? 0) " )
                                Text( "EGP".localized)
                            }
                                .font(.semiBold(size: 16))
                                .foregroundStyle(Color.white)
                            
//                            HStack{
                                Text("\(packageData?.priceBeforeDiscount ?? 0) " + "EGP".localized).strikethrough().foregroundStyle(Color(.secondary))
                                    .font(.semiBold(size: 12))
                                
                                (Text("(".localized + "Discount".localized ) + Text( " \(packageData?.discount ?? 0)" + "%".localized + ")".localized))
                                    .font(.semiBold(size: 12))
                                    .foregroundStyle(Color.white)
//                            }
//                            .padding(.top,2)
                        }
                    }
//                    .offset(y:-12)
                    .padding()
                    .frame(height: 101)
                    .background(Color.mainBlue)
                    .cardStyle( cornerRadius: 3)
                        
                    }
                    .padding([.horizontal,.top],15)
                    .padding(.top,5)

                    
//                    Spacer()
                    
                    SectionHeader(image: Image(.newreschedual),imageForground: Color(.secondary),title: "Schedualling_".localized,subTitle:
                        Text("schedualling_Hint".localized)
                        .foregroundStyle(Color(.secondary))
                        .font(.medium(size: 10))
                        .frame(maxWidth:.infinity,alignment: .leading)
                    ){
                        //                            go to last mes package
                    }
                    .padding()
                    
//                    YearMonthPickerView(selectedDate: $selectedDate)
                                        
                    HStack{
                        Button(action: {
                            showingDatePicker = true

                        }, label: {
                            HStack(alignment: .center){
                                Text(selectedDate,format:.customDateFormat("MMM - yyyy"))
                                    .foregroundStyle(Color(.mainBlue))
                                    .font(.medium(size: 12))
                                
                                Image(systemName: "chevron.forward")
                                    .font(.system(size: 8))
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(Color.white)
//                                    .padding(6)
                                    .background(Color(.secondary).cornerRadius(1))
                            }
                        })
                        .customSheet(isPresented: $showingDatePicker,height: 250, radius: 12, content: {
                            VStack(spacing:0){
                                MonthYearPicker(date: $selectedDate)
                                    .frame(maxHeight: .infinity) // Adjust height
                                Button(action: {
                                    showingDatePicker = false
                                    guard selectedDate != viewModel.newDate else {return}
                                    viewModel.newDate = selectedDate
                                }) {
                                    Text("Done".localized)
                                        .font(.bold(size: 16))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background{LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing)}
                                        .cardStyle(cornerRadius: 6)
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            }

                        })
                        .task(id: viewModel.newDate){
                                await viewModel.getAvailableDays()
                        }
                        
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        
                        HStack{
                            ForEach(viewModel.availableDays ?? [],id: \.self){day in
                                Button(action: {
                                    viewModel.selectedDay = day
                                }, label: {
                                    VStack{

                                        Text("\(day.date ?? "")".ChangeDateFormat(FormatFrom: "yyyy-MM-dd'T'HH:mm:ss", FormatTo: "dd"))
                                            .font(.semiBold(size: 14))

                                        Text(day.dayName ?? "")
                                            .font(.medium(size: 10))
                                    }
                                    .frame(width: 40, height: 50)
                                })
                                .foregroundStyle(Color.white)
                                .background(Color(.mainBlue))
                                .cardStyle(cornerRadius: 2)
                                .padding(2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    GeometryReader { geometry in
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            
                            HStack(alignment: .center,spacing: 5){
                                ForEach(viewModel.availableShifts ?? [],id: \.self){shift in
                                    Button(action: {
                                        viewModel.selectedShift = shift
                                    }, label: {
                                        VStack(spacing: 5){
                                            Text(shift.name ?? "")
                                                .font(.bold(size: 10))
                                            
                                            (Text("\(shift.timeFrom ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")) + Text(" - ") + Text("\(shift.timeTo ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")))
                                                .font(.medium(size: 9))
                                        }
                                        
                                    })
                                    .frame( height: 36)
                                    .frame(width: (geometry.size.width/3) - 15)
                                    .foregroundStyle(viewModel.selectedShift == shift ? Color.white : Color(.secondary))
                                    .cardStyle(backgroundColor: viewModel.selectedShift == shift ? Color(.secondary) : Color(.wrongsurface),cornerRadius: 2,shadowOpacity:0)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    SshedualsGrid(scheduals:viewModel.availableScheduals,selectedschedual:$viewModel.selectedSchedual)
                        .padding(.top)
                    
                    Button(action: {

                    }){
                            //
                            Text("Continue_".localized)
                        .font(.bold(size: 18))
                        .foregroundStyle(Color.white)
                        .frame(height:50)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal,10)
                        .background{LinearGradient(gradient: Gradient(colors: [.mainBlue, Color(.secondary)]), startPoint: .leading, endPoint: .trailing)}
                        .cornerRadius(3)
                    }
                    .padding()
                    
                    Spacer().frame(height: 55)
                }
            }
            .edgesIgnoringSafeArea([.top,.horizontal])
            .task{
//                viewModel.doctor = doctor
                await viewModel.getDoctorPackageDetails(doctorPackageId: doctorPackageId)
                await viewModel.getAvailableDays()
                await viewModel.getAvailableShifts()
            }
    }
}

#Preview {
    PackageMoreDetailsView(doctorPackageId: 0)
}

struct SshedualsGrid: View {
    
    var scheduals : [AvailableSchedualsM]?
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
   @Binding var selectedschedual : AvailableSchedualsM?
    var body: some View {
        VStack{
            if let scheduals = scheduals {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(scheduals, id: \.self) { item in
                        Button(action: {
                            selectedschedual = item
                        }, label: {
                            (Text("\(item.timefrom ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")) + Text(" - ") + Text("\(item.timeTo ?? "")".ChangeDateFormat(FormatFrom: "HH:mm:ss", FormatTo: "hh:mm a")))
                                .font(.medium(size: 8))
                                .foregroundStyle(item.booked ?? false ? Color(.btnDisabledTxt) : (selectedschedual == item ? Color(.white) : Color(.secondary)))
                        })
                        .padding()
                        .frame(height:20)
                        .cardStyle(backgroundColor: (item.booked ?? false ? Color(.btnDisabledBg) : (selectedschedual == item ? Color(.secondary) : Color(.clear)))
                                   ,cornerRadius: 3
                                   ,shadowOpacity:0
                                   ,borderColor: item.booked ?? false ? .clear : Color(.secondary)
                        )
                        .disabled(item.booked ?? false)
                    }
                }
                .padding(10)
                .cardStyle(backgroundColor: .white,cornerRadius: 5,shadowOpacity:0.09)
                .padding()
                
                //            .padding(.horizontal)
                //            .padding(.vertical,5)
                
            }
        }
        .padding(.vertical,5)
        .padding(.bottom,5)
            
    }
}
