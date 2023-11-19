import Foundation
import SwiftUI
import SwiftUICharts
import FSCalendar
import UIKit

struct RecordPageView: View {
    // access records stored in db
    @State private var records: [Record] = []
    @State private var data: [(String, Double)] = []
    @State private var dailyData: [(String, Double)] = []

    var body: some View {
        VStack {
            CalendarView()

            BarChartView(
                data: ChartData(values: dailyData),
                title: "WeightPrint",
                style: Styles.barChartStyleNeonBlueLight,
                form: ChartForm.extraLarge
            ).padding()
        }
        .onAppear {
            retrieveRecords()
        }
    }

    private func retrieveRecords() {
        FirebaseDataManager.retrieveRecords { records in
            self.records = records
            self.data = Array(zip(records.map{$0.timestamp}, records.map{$0.weight}))
            var dict: [String: String] = [:] // Last timestamp for each day
            for (str, _) in data {
                let key = String(str.components(separatedBy: " ")[0])
                dict[key] = str
            }
            self.dailyData = data.filter { dict.values.contains($0.0) }.suffix(30).map {
                (datetime, weight) in
                let dateString = datetime.components(separatedBy: " ")[0]
                return (dateString, weight)
            }
        }
    }
}

struct MealRecord: View {
    @State var time: String
    @State var food: String
    @State var calories: Int
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 350, height: 1)
                .foregroundColor(.gray)
            
            HStack {
                Text(formatTime(time))
                    .font(.custom("Kalam-Regular", size: 15))
                    .foregroundColor(.black)
                    .padding()
                Text("\(food)")
                    .font(.custom("Kalam-Regular", size: 15))
                    .foregroundColor(.black)
                    .padding()
                Text("\(calories)")
                    .font(.custom("Kalam-Regular", size: 15))
                    .foregroundColor(.black)
                    .padding()
                
                Image(systemName: "pencil.and.outline")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue.opacity(0.5))
                    .padding()
            }
        }
    }
    private func formatTime(_ timestamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let date = dateFormatter.date(from: timestamp) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
        }
        
        return ""
    }
    
}

struct MealRecordSheet: View {
    @Binding var selectedDate: Date
    @State private var records: [Record] = []

    var body: some View {
        ScrollView{
            VStack {
                HStack (spacing: 20){
                    Image(systemName: "fork.knife")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue.opacity(0.5))
                    
                    Text("Meal Records")
                        .font(.custom("Kalam-Bold", size: 35))
                        .foregroundColor(.black)
                    
                }
                .padding(.top, 20)
                .padding(.bottom, 0)
                
                let formattedDate = formattedDate(_: selectedDate)
                
                Text("Date: \(Text(formattedDate).foregroundColor(.blue))")
                    .font(.custom("Kalam-Bold", size: 25))
                    .foregroundColor(.black)
                    .padding(.bottom, 30)
                HStack {
                    Text("Time")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .padding()
                    Text("Food")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .padding()
                    Text("Calories")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .padding()
                    Text("Edit")
                        .font(.custom("Kalam-Bold", size: 15))
                        .foregroundColor(.black)
                        .padding()
                }
                
                if records.isEmpty {
                    Text("No meal record for this date")
                        .font(.custom("Kalam-Bold", size: 25))
                        .foregroundColor(.black)
                        .padding(.top, 50)
                } else {
                    ForEach(records, id: \.timestamp) { record in
                        MealRecord(time: record.timestamp, food: record.foodCategory, calories: record.calories)
                    }
                }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.gray)
                
            }
        }
        .onAppear{
            retrieveRecords(for: selectedDate)
        }
    }
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter.string(from: date)
    }
    
    private func retrieveRecords(for date: Date) {
        FirebaseDataManager.retrieveRecords { records in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            let filteredRecords = records.filter { record in
                guard let recordDate = dateFormatter.date(from: record.timestamp) else {
                    return false
                }
                let recordDateStartOfDay = Calendar.current.startOfDay(for: recordDate)
                let filterDateStartOfDay = Calendar.current.startOfDay(for: date)
                return recordDateStartOfDay == filterDateStartOfDay
            }
            
            self.records = filteredRecords
        }
    }
}


struct CalendarView: View {
    @State private var isDataFetched = false
    @State var selectedDate: Date = Date()
    @State var isSheetVisible = false
    @State private var records: [Record] = []
    
    var body: some View {
        VStack {
            if isDataFetched {
                CalendarViewRepresentable(selectedDate: $selectedDate, isSheetVisible: $isSheetVisible, records: $records)
                    .sheet(isPresented: $isSheetVisible) {
                        MealRecordSheet(selectedDate: $selectedDate)
                    }
            }else {
                Text("Loading...")
                    .font(.custom("Kalam-Bold", size: 30))
                    .foregroundColor(.black)
                    .padding(.bottom, 50)
            }
        }
        .onAppear{
            fetchDataFromDatabase { fetchedRecords in
                records = fetchedRecords
                isDataFetched = true
            }
        }
    }
    func fetchDataFromDatabase(completion: @escaping ([Record]) -> Void) {
        FirebaseDataManager.retrieveRecords { records in
            completion(records)
        }
    }
}

class RecordStore: ObservableObject {
    @Published var records: [Record] = []
    
    func retrieveRecords() {
        FirebaseDataManager.retrieveRecords { [weak self] records in
            DispatchQueue.main.async {
                self?.records = records
                print(records)
            }
        }
    }
}
    
struct CalendarViewRepresentable: UIViewRepresentable {
        typealias UIViewType = FSCalendar
        @Binding var selectedDate: Date
        @Binding var isSheetVisible: Bool
        @Binding var records: [Record]
        
        func makeUIView(context: Context) -> FSCalendar {
            let calendar = FSCalendar()
            calendar.appearance.headerTitleFont = UIFont(name: "Kalam-Bold", size: 25)
            calendar.appearance.headerTitleColor = .blue
            calendar.appearance.headerDateFormat = "MMMM"
            calendar.appearance.titleFont = UIFont(name: "Kalam-Bold", size: 17)
            calendar.appearance.weekdayFont = UIFont(name: "Kalam-Bold", size: 17)
            calendar.appearance.weekdayTextColor = .blue.withAlphaComponent(0.5)
            calendar.dataSource = context.coordinator
            calendar.delegate = context.coordinator
            calendar.scrollDirection = .horizontal
            return calendar
        }
        func updateUIView(_ uiView: FSCalendar, context: Context) {
            
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
            var parent: CalendarViewRepresentable
            
            init(_ parent: CalendarViewRepresentable) {
                self.parent = parent
                print(parent.records)
            }
            
            func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
                let calendar = Calendar.current
                let day = calendar.component(.day, from: date)
                return day % 2 == 0 ? 0 : 0
                
            }
            
            func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                //            parent.selectedDate = date
                parent.$selectedDate.wrappedValue = date
                parent.isSheetVisible = true
            }
            func maximumDate(for calendar: FSCalendar) -> Date {
                Date.now.addingTimeInterval(86400 * 30)
            }
            
            func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let selectedDate = calendar.startOfDay(for: date)
                if selectedDate == today {
                    return UIColor.blue.withAlphaComponent(0.3)
                } else if selectedDate > today {
                    return nil
                } else if selectedDate < calendar.date(from: DateComponents(year: calendar.component(.year, from: today), month: 9, day: 1))! { // no data before 9/1
                    return UIColor.white
                } else if SuccessOrNot(date: date) {
                    return UIColor.green.withAlphaComponent(0.3)
                } else if !SuccessOrNot(date: date) {
                    return UIColor.red.withAlphaComponent(0.3)
                } else {
                    return UIColor.white
                }
            }
            
            func SuccessOrNot(date: Date) -> Bool {
                if parent.records.isEmpty {
                    print("Records array is empty")
                    return false
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                
                let filteredRecords = parent.records.filter { record in
                    guard let recordDate = dateFormatter.date(from: record.timestamp) else {
                        return false // Invalid timestamp format
                    }
                    return Calendar.current.isDate(recordDate, inSameDayAs: date)
                }
                
                guard let firstRecord = filteredRecords.min(by: { dateFormatter.date(from: $0.timestamp)! < dateFormatter.date(from: $1.timestamp)! }),
                      let lastRecord = filteredRecords.max(by: { dateFormatter.date(from: $0.timestamp)! < dateFormatter.date(from: $1.timestamp)! }) else {
                    print("No records found for the specified date")
                    return false // No records found for the specified date
                }
                
                guard let firstRecordDate = dateFormatter.date(from: firstRecord.timestamp),
                      let lastRecordDate = dateFormatter.date(from: lastRecord.timestamp) else {
                    print("Invalid timestamp format")
                    return false // Invalid timestamp format
                }

                let timeDifference = lastRecordDate.timeIntervalSince(firstRecordDate)
                let hoursDifference = timeDifference / 3600 // Convert seconds to hours
                return hoursDifference < 8
            }
        }
    }

struct RecordPageView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageView()
    }
}
