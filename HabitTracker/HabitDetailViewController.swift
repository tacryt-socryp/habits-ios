//
//  HabitDetailViewController.swift
//  Tailor
//
//  Created by Logan Allen on 2/6/16.
//  Copyright © 2016 Logan Allen. All rights reserved.
//

import UIKit
import Charts

class HabitDetailViewController: UIViewController, ChartViewDelegate {

    // MARK: - Attributes

    @IBOutlet weak var barChartView: BarChartView!
    var dataController: DataController!
    var habit: Habit! {
        didSet {
            self.configureView()
        }
    }


    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureBarChart()
    }

    func configureView() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editHabit")
        self.navigationItem.rightBarButtonItem = editButton
    }


    // MARK: - Charts

    func configureBarChart() {
        barChartView.delegate = self
        barChartView.descriptionText = ""
        barChartView.noDataTextDescription = "Data will be loaded soon."

        barChartView.maxVisibleValueCount = 60
        barChartView.pinchZoomEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.maxVisibleValueCount = 0
        barChartView.backgroundColor = Constants.Colors.darkPrimary
        barChartView.borderColor = UIColor.whiteColor()
        barChartView.descriptionTextColor = UIColor.whiteColor()
        // barChartView.gridBackgroundColor

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
            yVals.append(BarChartDataEntry(value: Double(idx), xIndex: idx))
        }

        let set1 = BarChartDataSet(yVals: yVals, label: "Day")
        set1.colors = [UIColor.whiteColor()]
        set1.barSpace = 0.25

        let data = BarChartData(xVals: xVals, dataSet: set1)
        data.setValueFont(UIFont.systemFontOfSize(14))
        data.setValueTextColor(UIColor.whiteColor())
        self.barChartView.data = data

        self.view.reloadInputViews()
    }

    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {

        // let markerPosition = chartView.getMarkerPosition(entry: entry,  highlight: highlight)

        // Adding top marker
//        floatingGraphReader.valueLabel.text = "\(entry.value)"
//        floatingGraphReader.dateLabel.text = "\(months[entry.xIndex])"
//        floatingGraphReader.center = CGPointMake(markerPosition.x, markerView.center.y)
//        floatingGraphReader.hidden = false

    }


    // MARK: - Segues

    func editHabit() {
        self.performSegueWithIdentifier(Constants.Segues.showEditHabit, sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.showEditHabit {
            let controller = segue.destinationViewController as! HabitViewController
            controller.dataController = self.dataController
            controller.currentState = [.Edit]
            controller.habit = habit
        }
    }

}
