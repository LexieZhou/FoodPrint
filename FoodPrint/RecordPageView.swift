
//  RecordPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI
import SwiftUICharts


struct RecordPageView: View {
    
    // the current date and time
    @State var selectedDate: Date = Date()
    // access records stored in db
    @State private var records: [Record] = []
    @State private var data: [(String, Double)] = []
    @State private var daily_data: [(String, Double)] = []
    
    var body: some View {
        VStack{
            VStack() {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(Color.accentColor)
                    .padding()
                    .animation(.spring(), value: selectedDate)
                    .frame(width: 500)
                Divider().frame(height: 1)
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .padding(.horizontal)
                    .datePickerStyle(.graphical)
                Divider()
            }
            BarChartView(
                data: ChartData(values: daily_data),
                title: "WeightPrint",
                style: Styles.barChartStyleNeonBlueLight,
                form: ChartForm.extraLarge
            ).padding()
        }.onAppear{
            retrieveRecords()
        }
    }
    
    private func retrieveRecords() {
        FirebaseDataManager.retrieveRecords { records in
            self.records = records
            self.data = Array(zip(records.map{$0.timestamp}, records.map{$0.weight}))
            var dict: [String: String] = [:] // Last timestemp for each day
                for (str, _) in data {
                    let key = String(str.components(separatedBy: " ")[0])
                    dict[key] = str
                }
            print(dict.values)
            self.daily_data = data.filter { dict.values.contains($0.0) }
        }
    }
}


struct RecordPageView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageView()
    }
}

