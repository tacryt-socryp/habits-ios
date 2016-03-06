//
//  GraphViewController.swift
//  Tailor
//
//  Created by Logan Allen on 3/4/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Charts
import Bond

class GraphViewController: UIViewController, AppViewController, ChartViewDelegate {

    var viewModel : GraphModel? = nil {
        didSet {
            self.bindModel()
        }
    }

    func setup(viewModel: ViewModel) {
        self.viewModel = viewModel as? GraphModel
        self.viewModel?.setup()
    }

    // use bond
    func bindModel() {
    }

    // MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    // MARK: - Charts

    func configureBarChart() {

        let barChartView = BarChartView(frame: self.view.bounds)
        barChartView.delegate = self
        barChartView.descriptionText = ""
        barChartView.noDataTextDescription = "Data will be loaded soon."

        barChartView.maxVisibleValueCount = 0
        barChartView.maxVisibleValueCount = 7

        barChartView.pinchZoomEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.dragEnabled = false

        barChartView.backgroundColor = Constants.Colors.accent
        barChartView.borderColor = UIColor.whiteColor()
        barChartView.descriptionTextColor = UIColor.whiteColor()
        barChartView.legend.textColor = UIColor.whiteColor()

        let yAxis = barChartView.getAxis(ChartYAxis.AxisDependency.Left)
        yAxis.drawGridLinesEnabled = false
        yAxis.labelTextColor = UIColor.whiteColor()
        yAxis.axisLineColor = UIColor.whiteColor()

        barChartView.getAxis(ChartYAxis.AxisDependency.Right).enabled = false


        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.labelTextColor = UIColor.whiteColor()
        barChartView.xAxis.axisLineColor = UIColor.whiteColor()
        barChartView.xAxis.gridColor = UIColor.whiteColor()


        // let entries = self.habit.entries
        let xVals = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var yVals: [BarChartDataEntry] = []


        for idx in 0...6 {
            yVals.append(BarChartDataEntry(value: Double(idx + 1), xIndex: idx))
        }

        let set1 = BarChartDataSet(yVals: yVals, label: "Day")
        set1.colors = [UIColor.whiteColor()]
        set1.barSpace = 0.25
        set1.highlightColor = Constants.Colors.normalPrimary

        let data = BarChartData(xVals: xVals, dataSet: set1)
        data.setValueFont(UIFont.systemFontOfSize(14))
        data.setValueTextColor(UIColor.whiteColor())
        barChartView.data = data

        self.view.reloadInputViews()
    }

    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let chartMarker = FloatingChartMarker()
        chartMarker.textLabel = "Hella" // probably just add textLabel to entry
        chartView.marker = chartMarker
        
    }

    // MARK: - User Events

}