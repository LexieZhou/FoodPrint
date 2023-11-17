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

struct CalendarView: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        calendar.scrollDirection = .horizontal
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Update the FSCalendar if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            return day % 2 == 0 ? 0 : 0
            
        }
        
        //need to check this code later...
        //        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        //            let calendar = Calendar.current
        //            let day = calendar.component(.day, from: date)
        //            return day % 2 == 0 ? .green : .red
        //        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let selectedDate = calendar.startOfDay(for: date)
            let day = calendar.component(.day, from: date)
            if selectedDate == today {
                return UIColor.blue.withAlphaComponent(0.3)
            } else if selectedDate > today {
                return nil
            } else if day % 5 == 0 {// when data is missing
                return UIColor.gray.withAlphaComponent(0.3)
            } else if day % 4 != 0 {// when data shows that fasting is success
                return UIColor.green.withAlphaComponent(0.3)
            } else if day % 4 == 0 {// when data shows that fasting is unsucess
                return UIColor.red.withAlphaComponent(0.3)
            } else {
                return UIColor.black.withAlphaComponent(0.3)
            }
        }
    }
}

struct RecordPageView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageView()
    }
}
