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
    
    
    @State private var timestamp: [String] = []
    @State private var height: [Double] = []
    @State private var weight: [Double] = []
    @State private var foodCategory: [String] = []
    @State private var calories: [Int] = []

    
    
    
    var body: some View {
        VStack {
            
            CalendarView().onAppear(){
                
            }
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
            
            self.timestamp = Array(records.map{$0.timestamp})
            self.height = Array(records.map{$0.height})
            self.weight = Array(records.map{$0.weight})
            self.foodCategory = Array(records.map{$0.foodCategory})
            self.calories = Array(records.map{$0.calories})
            
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
    
    @State private var records: [Record] = []
    @State private var data: [(String, Double)] = []
    @State private var dailyData: [(String, Double)] = []
    
    @State private var timestamp: [String] = []
    @State private var height: [Double] = []
    @State private var weight: [Double] = []
    @State private var foodCategory: [String] = []
    @State private var calories: [Int] = []
    
    func retrieveRecords(completion: @escaping () -> Void) {
        FirebaseDataManager.retrieveRecords { records in
            self.records = records
            
            self.timestamp = Array(records.map{$0.timestamp})
            self.height = Array(records.map{$0.height})
            self.weight = Array(records.map{$0.weight})
            self.foodCategory = Array(records.map{$0.foodCategory})
            self.calories = Array(records.map{$0.calories})
            //let _ = print(timestamp)
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
            completion()
        }
    }
    
    
    func makeUIView(context: Context) -> FSCalendar {
            let calendar = FSCalendar()
            calendar.dataSource = context.coordinator
            calendar.delegate = context.coordinator
            calendar.scrollDirection = .horizontal
            
            return calendar
        }
        
        func updateUIView(_ uiView: FSCalendar, context: Context) {
            // Update the FSCalendar if needed
            retrieveRecords {
                let coordinator = context.coordinator
                coordinator.timestamp = self.timestamp
                coordinator.height = self.height
                coordinator.weight = self.weight
                coordinator.foodCategory = self.foodCategory
                coordinator.calories = self.calories
                
                
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator()
        }
    
    class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
        var records: [Record] = []
        var timestamp: [String] = []
        var height: [Double] = []
        var weight: [Double] = []
        var foodCategory: [String] = []
        var calories: [Int] = []
        
        override init() {}
        
        func retrieveRecords(completion: @escaping () -> Void) {
            FirebaseDataManager.retrieveRecords { records in
                self.records = records
                
                self.timestamp = Array(records.map{$0.timestamp})
                self.height = Array(records.map{$0.height})
                self.weight = Array(records.map{$0.weight})
                self.foodCategory = Array(records.map{$0.foodCategory})
                self.calories = Array(records.map{$0.calories})
                
                var dict: [String: String] = [:] // Last timestamp for each day
                //print(self.records)
                completion()
            }
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
                var color: UIColor?
                // Retrieve records and execute the appearance configuration after data retrieval
                retrieveRecords {
                    //print(self.timestamp)
                    //print(self.weight)
                    //print(self.height)
                    //print(self.foodCategory)
                    //print(self.calories)
                    
                    
                    
                    // Perform appearance configuration based on the retrieved data
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm" // Replace with your actual timestamp format
                    
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let selectedDate = calendar.startOfDay(for: date)
                    let day = calendar.component(.day, from: date)
                    
                    // Perform the appearance configuration based on the retrieved data
                    if selectedDate == today {
                        color = UIColor.blue.withAlphaComponent(0.3)
                    } else if selectedDate > today {
                        color = nil
                    } else if day % 5 == 0 { // when data is missing
                        color = UIColor.white
                    } else if day % 4 != 0 { // when data shows that fasting is successful
                        color = UIColor.green.withAlphaComponent(0.3)
                    } else if day % 4 == 0 { // when data shows that fasting is unsuccessful
                        color = UIColor.red.withAlphaComponent(0.3)
                    } else {
                        color = UIColor.black.withAlphaComponent(0.3)
                    }
                }
                
                return color
            }
    }
}

struct RecordPageView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageView()
    }
}
