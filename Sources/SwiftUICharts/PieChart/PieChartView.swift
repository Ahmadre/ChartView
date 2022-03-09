//
//  PieChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartView : View {
    public var data: [PieData]
    public var title: String?
    public var legend: String?
    public var style: ChartStyle
    public var formSize:CGSize
    public var dropShadow: Bool
    public var showPreview: Bool
    public var valueSpecifier:String
    public var padding: Double
    
    @State private var showValue = false
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }
    
    public init(data: [PieData], title: String? = nil, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, showPreview: Bool? = true, valueSpecifier: String? = "%.1f", padding: Double? = 12){
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.showPreview = showPreview!
        self.valueSpecifier = valueSpecifier!
        self.padding = padding!
    }
    
    public var body: some View {
        ZStack{
            Rectangle()
                .fill(self.style.backgroundColor)
                .cornerRadius(20)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 12 : 0)
            VStack(alignment: .leading){
                HStack{
                    if(!showValue){
                        if (self.title != nil) {
                            Text(self.title!)
                                .font(.headline)
                                .foregroundColor(self.style.textColor)
                        }                        
                    }else{
                        Text("\(self.currentValue, specifier: self.valueSpecifier)")
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }
                    if (showPreview) {
                        Spacer()
                        Image(systemName: "chart.pie.fill")
                            .imageScale(.large)
                            .foregroundColor(self.style.legendTextColor)
                    }
                    
                }.padding()
                PieChartRow(data: data, backgroundColor: self.style.backgroundColor, accentColor: self.style.accentColor, showValue: $showValue, currentValue: $currentValue)
                    .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : self.padding).offset(y:self.legend != nil ? 0 : -10)
                if(self.legend != nil) {
                    Text(self.legend!)
                        .font(.headline)
                        .foregroundColor(self.style.legendTextColor)
                        .padding()
                }
                
            }
        }.frame(width: self.formSize.width, height: self.formSize.height)
    }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
    static var previews: some View {
        PieChartView(data: [
            PieData(value: 56, color: Color.teal),
            PieData(value: 78, color: Color.blue),
            PieData(value: 53, color: Color.red),
            PieData(value: 65, color: Color.green),
            PieData(value: 54, color: Color.yellow),
        ], title: "Title", legend: "Legend")
    }
}
#endif
