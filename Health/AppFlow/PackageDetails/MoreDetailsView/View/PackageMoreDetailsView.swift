//
//  PackageMoreDetailsView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/05/2025.
//

import SwiftUI

struct PackageMoreDetailsView: View {
    var doctorId: Int
    @StateObject var viewModel = PackageMoreDetailsViewModel.shared
    
    @State private var showingDatePicker = false
    @State private var selectedDate = Date()
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM - yyyy"
        return formatter.string(from: date)
    }
    
    init(doctorId: Int) {
        self.doctorId = doctorId
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
                                    Text("صحة عامة")
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
                        
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack{
                            ForEach(0...16,id: \.self){day in
                                Button(action: {
                                    
                                }, label: {
                                    VStack{
                                        Text(day,format: .number)
                                            .font(.semiBold(size: 14))

                                        Text("السبت")
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
                    
                    
                    Spacer().frame(height: 55)
                }
            }
            .edgesIgnoringSafeArea([.top,.horizontal])
            .task{
                await viewModel.getAvailableDoctors(doctorId: doctorId)
            }
    }
}

#Preview {
    PackageMoreDetailsView(doctorId: 0)
}

//
//struct YearMonthPickerView: View {
//    @Binding var selectedDate: Date
//    
//    private let months: [String]
//    private let columns = [
//        GridItem(.adaptive(minimum: 80))
//    ]
//    
//    init(selectedDate: Binding<Date>, locale: Locale = .current) {
//        self._selectedDate = selectedDate
//        let calendar = Calendar.current
//        var tempMonths = calendar.shortMonthSymbols
//        // Ensure we have exactly 12 months
//        self.months = Array(tempMonths.prefix(12))
//    }
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            // Year picker
//            yearPickerView()
//                .padding(.horizontal)
//            
//            // Month picker
//            monthGridView()
//                .padding(.horizontal)
//        }
//        .padding(.vertical)
//    }
//    
//    private func yearPickerView() -> some View {
//        let currentYear = Calendar.current.component(.year, from: Date())
//        let selectedYear = Calendar.current.component(.year, from: selectedDate)
//        
//        return HStack(spacing: 16) {
//            Button {
//                changeYear(by: -1)
//            } label: {
//                Image(systemName: "chevron.left")
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(selectedYear <= currentYear ? .gray : .blue)
//            }
//            .disabled(selectedYear <= currentYear)
//            
//            Text(selectedDate, format: .dateTime.year())
//                .font(.semiBold(size: 16))
//                .frame(height: 30)
//                .frame(maxWidth: .infinity)
//                .foregroundStyle(Color(.main))
//            
//            Button {
//                changeYear(by: 1)
//            } label: {
//                Image(systemName: "chevron.right")
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(.blue)
//            }
//        }
//        .buttonStyle(.plain)
//    }
//    
//    private func monthGridView() -> some View {
//        LazyVGrid(columns: columns, spacing: 12) {
//            ForEach(0..<12, id: \.self) { monthIndex in
//                let monthName = months[monthIndex]
//                let isSelected = Calendar.current.component(.month, from: selectedDate) == monthIndex + 1
//
//                Button {
//                    selectMonth(monthIndex + 1)
//                } label: {
//                    Text(monthName)
//                        .font(.semiBold(size: 16))
//                        .frame(height: 30)
//                        .frame(maxWidth: .infinity)
//                        .padding(10)
//                        .background(isSelected ? Color(.secondary) : Color(.main))
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .buttonStyle(.plain)
//            }
//        }
//    }
//    
//    private func changeYear(by delta: Int) {
//        let calendar = Calendar.current
//        let currentYear = calendar.component(.year, from: selectedDate)
//        let newYear = currentYear + delta
//        
//        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
//        components.year = newYear
//        
//        if let newDate = calendar.date(from: components) {
//            selectedDate = newDate
//        }
//    }
//    
//    private func selectMonth(_ month: Int) {
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
//        components.month = month
//        
//        if let newDate = calendar.date(from: components) {
//            selectedDate = newDate
//        }
//    }
//}
//
//// Preview
//struct YearMonthPickerView_Previews: PreviewProvider {
//    @State static var date = Date()
//    
//    static var previews: some View {
//        YearMonthPickerView(selectedDate: $date)
//            .previewLayout(.sizeThatFits)
//    }
//}


struct CustomDateFormat: FormatStyle {
    let format: String
    let locale: Locale
    
    func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: value)
    }
}

extension FormatStyle where Self == CustomDateFormat {
    static func customDateFormat(_ format: String, locale: Locale = .current) -> CustomDateFormat {
        CustomDateFormat(format: format, locale: locale)
    }
}





import SwiftUI

struct MonthYearPicker: UIViewRepresentable {
    @Binding var date: Date
    
    func makeUIView(context: Context) -> MonthYearWheelPicker {
        let picker = MonthYearWheelPicker()
        picker.date = date
        picker.onDateSelected = { month, year in
            var components = Calendar.current.dateComponents([.year, .month], from: date)
            components.year = year
            components.month = month
            date = Calendar.current.date(from: components) ?? date
        }
        return picker
    }
    
    func updateUIView(_ uiView: MonthYearWheelPicker, context: Context) {
        uiView.date = date
    }
}

//
//  MonthYearPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//  Modified by Jiayang Miao on 24/10/2016 to support Swift 3
//  Modified by David Luque on 24/01/2018 to get default date
//  Rewritten by Ben Dodson on 01/06/2022 to support Swift 5 / SPM
//
import UIKit

/// A control for the inputting of month and year values in a view that uses a spinning-wheel or slot-machine metaphor.
open class MonthYearWheelPicker: UIPickerView {
    
    private var calendar = Calendar(identifier: .gregorian)
    private var _maximumDate: Date?
    private var _minimumDate: Date?
    private var _date: Date?
    private var months = [String]()
    private var years = [Int]()
    private var target: AnyObject?
    private var action: Selector?
    
    /// The maximum date that a picker can show.
    ///
    /// Use this property to configure the maximum date that is selected in the picker interface. The default is the current month and 15 years into the future.
    open var maximumDate: Date {
        set {
            _maximumDate = formattedDate(from: newValue)
            updateAvailableYears(animated: false)
        }
        get {
            return _maximumDate ?? formattedDate(from: calendar.date(byAdding: .year, value: 15, to: Date()) ?? Date())
        }
    }
    
    /// The minimum date that a picker can show.
    ///
    /// Use this property to configure the minimum date that is selected in the picker interface. The default is the current month and year.
    open var minimumDate: Date {
        set {
            _minimumDate = formattedDate(from: newValue)
            updateAvailableYears(animated: false)
        }
        get {
            return _minimumDate ?? formattedDate(from: Date())
        }
    }
    
    /// The date displayed by the picker.
    ///
    /// Use this property to get and set the currently selected date. The default value of this property is the date when the UIDatePicker object is created. Setting this property animates the date picker by spinning the wheels to the new date and time; if you don't want any animation to occur when you set the date, use the ``setDate(_:animated:)`` method, passing `false` for the animated parameter.
    ///
    /// - Note: If you attempt to set the date beyond the ``maximumDate``or below the ``minimumDate`` then the date will be corrected to the closest date within those bounds (i.e. if your maximum date is set to 1st June 2022 and you try to set the date as 1st January 2023, the date that will actually be set will be 1st June 2022). Also note that dates will be converted so they become the first of the month at midnight (i.e. if you set the date to 21st September 2022 @ 15:33 then the returned date will be 1st September 2022 @ 00:00).
    open var date: Date {
        set {
            setDate(newValue, animated: true)
        }
        get {
            return _date ?? formattedDate(from: Date())
        }
    }
    
    /// The month displayed by the picker.
    ///
    /// Use this property to get the current month in the Gregorian calendar starting from `1` for _January_ through to `12` for _December_.
    open var month: Int {
        return calendar.component(.month, from: date)
    }
    
    /// The year displayed by the picker.
    ///
    /// Use this property to get the current year in the Gregorian calendar.
    open var year: Int {
        return calendar.component(.year, from: date)
    }
    
    /// A completion handler to receive the month and year when the picker value is changed.
    open var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    /// Associates a target object and action method with the control.
    ///
    /// - parameter target: The target object—that is, the object whose action method is called. If you specify nil, UIKit searches the responder chain for an object that responds to the specified action message and delivers the message to that object.
    /// - parameter action: A selector identifying the action method to be called. This parameter must not be nil.
    /// - parameter controlEvents: A bitmask specifying the control-specific events for which the action method is called. This control only supports `.valueChanged`.
    /// - Note: `MonthYearWheelPicker` does not inherit from `UIControl` so this method is provided only as a way for it be a drop-in replacement for `UIDatePicker` in most scenarios. You can only use the `.valueChanged` control event and you may only set one active target; multiple calls to this method will mean the last call is used as the target / action.
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        removeTarget()
        guard controlEvents == .valueChanged else {
            return
        }
        self.target = target as? AnyObject
        self.action = action
    }
    
    /// Stops the delivery of events to the previously set target object.
    public func removeTarget() {
        self.target = nil
        self.action = nil
    }
    
    /// Stops the delivery of events to the previously set target object.
    ///
    /// - Note: `MonthYearWheelPicker` does not inherit from `UIControl` so this method is provided only as a way for it be a drop-in replacement for `UIDatePicker` in most scenarios. The parameters used here are meaningless as any call to this method will result in the previously set target / action being removed.
    public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
        removeTarget()
    }
    
    /// Sets the date to display in the date picker, with an option to animate the setting.
    ///
    /// - parameter date: An `NSDate` object representing the new date to display in the date picker.
    /// - parameter animated: `true` to animate the setting of the new date, otherwise `false`. The animation rotates the wheels until the new month and year is shown under the highlight rectangle.
    /// - Note: If you attempt to set the date beyond the ``maximumDate``or below the ``minimumDate`` then the date will be corrected to the closest date within those bounds (i.e. if your maximum date is set to 1st June 2022 and you try to set the date as 1st January 2023, the date that will actually be set will be 1st June 2022).
    public func setDate(_ date: Date, animated: Bool) {
        let date = formattedDate(from: date)
        _date = date
        if date > maximumDate {
            setDate(maximumDate, animated: true)
            return
        }
        if date < minimumDate {
            setDate(minimumDate, animated: true)
            return
        }
        updatePickers(animated: animated)
    }
    
    
    // MARK: Private methods
    
    private func updatePickers(animated: Bool) {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        DispatchQueue.main.async {
            self.selectRow(month - 1, inComponent: 0, animated: animated)
            if let firstYearIndex = self.years.firstIndex(of: year) {
                self.selectRow(firstYearIndex, inComponent: 1, animated: animated)
            }
        }
    }
    
    private func pickerViewDidSelectRow() {
        let month = selectedRow(inComponent: 0) + 1
        let year = years[selectedRow(inComponent: 1)]
        guard let date = DateComponents(calendar: calendar, year: year, month: month, day: 1, hour: 0, minute: 0, second: 0).date else {
            fatalError("Could not generate date from components")
        }
        self.date = date
        
        if let block = onDateSelected {
            block(month, year)
        }
        
        if let target = target, let action = action {
            _ = target.perform(action, with: self)
        }
    }
    
    private func formattedDate(from date: Date) -> Date {
        return DateComponents(calendar: calendar, year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1, hour: 0, minute: 0, second: 0).date ?? Date()
    }
    
    private func updateAvailableYears(animated: Bool) {
        var years = [Int]()
        
        let startYear = calendar.component(.year, from: minimumDate)
        let endYear = max(calendar.component(.year, from: maximumDate), startYear)
        
        while years.last != endYear {
            years.append((years.last ?? startYear - 1) + 1)
        }
        self.years = years
        
        updatePickers(animated: animated)
    }
    
    private func commonSetup() {
        delegate = self
        dataSource = self
        
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        updateAvailableYears(animated: false)
    }
}

extension MonthYearWheelPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewDidSelectRow()
        if component == 1 {
            pickerView.reloadComponent(0)
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var text: String?
        switch component {
        case 0:
            text = months[row]
        case 1:
            text = "\(years[row])"
        default:
            return nil
        }
        
        guard let text = text else { return nil }

        var attributes = [NSAttributedString.Key: Any]()
        if #available(iOS 13.0, *) {
            attributes[.foregroundColor] = UIColor.label
        } else {
            attributes[.foregroundColor] = UIColor.black
        }
        
        if component == 0 {
            let month = row + 1
            let year = years[selectedRow(inComponent: 1)]
            if let date = DateComponents(calendar: calendar, year: year, month: month, day: 1, hour: 0, minute: 0, second: 0).date, date < minimumDate || date > maximumDate {
                if #available(iOS 13.0, *) {
                    attributes[.foregroundColor] = UIColor.secondaryLabel
                } else {
                    attributes[.foregroundColor] = UIColor.gray
                }
            }
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
}


struct CustomHeightSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var height: CGFloat?
    var radius: CGFloat?

    let sheetContent: () -> SheetContent

    @ViewBuilder
    func sheetBody() -> some View {
        if #available(iOS 16.4, *) {
            sheetContent()
                .presentationDetents([.height(height ?? 300)])
                .presentationCornerRadius(radius ?? 12)
        } else {
            sheetContent()
                .frame(height: height)
                .cornerRadius(radius ?? 12)
        }
    }

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            sheetBody()
        }
        .background(Color(.systemBackground))

    }
}

extension View {
    func customSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat? = nil,
        radius: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(CustomHeightSheetModifier(isPresented: isPresented, height: height,radius: radius, sheetContent: content))
    }
}
