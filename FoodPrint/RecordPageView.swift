
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
                data: ChartData(
                values: [
                ("2023-09-01", 60),
                ("2023-09-02", 59),
                ("2023-09-03", 55),
                ("2023-09-04", 53),
                ("2023-09-05", 51),
                ("2023-09-06", 50),
                ("2023-09-07", 40),
                ]),
                title: "7-day Weight",
                style: Styles.barChartStyleNeonBlueLight,
                form: ChartForm.extraLarge
            ).padding()
            let _ = retrieveRecords()
        }
    }
    
    private func retrieveRecords() {
        FirebaseDataManager.retrieveRecords { records in
            self.records = records // Store the retrieved records in the state property
            // Perform any other actions with the retrieved records if needed
            print(records[0].foodCategory)
            print(records[0].weight)
            print(records[0].calories)
        }
    }
}

struct RecordPageView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageView()
    }
}
