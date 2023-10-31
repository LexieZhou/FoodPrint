//
//  RecordPageView.swift
//  FoodPrint
//
//  Created by Lexie Zhou on 3/10/2023.
//

import Foundation
import SwiftUI
import SwiftUICharts


struct RecordPageView: View {
    private let data: [Double] = [42.0, 25.8, 88.19, 15.0, 17]
    private let labels: [String] = ["The answer", "Birthday", "2021-11-21", "My number"]
    // the current date and time
    @State var selectedDate: Date = Date()
    
    
    
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
            Spacer()
            
            LineChartView(data: data, title: "7-day Weight")
                .frame(width: 700, height: 300)
        }
        
    }
}

struct RecordPageView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPageView()
    }
}
