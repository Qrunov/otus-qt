/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtCharts 2.2
import QtQuick.Controls 2.15

Flickable {
    id: space
    width: parent.width
    boundsBehavior: Flickable.StopAtBounds
    property var jsonStr;
    ChartView {
        id: chartView
        width: parent.width    // ← Авторесайз по родителю
        height: parent.height
        theme: ChartView.ChartThemeLight
        legend.alignment: Qt.AlignBottom
        antialiasing: true

        property var jsonStr: parent.jsonStr;
        CandlestickSeries {
            axisY: ValueAxis{
                id: aY
                min: -20
                max: 20
            }

            axisX: DateTimeAxis {
                id: aX
                format: "dd.MM.yy"
                tickCount: 5
            }

            name: qsTr("Погодный график")
            id:  candleSeries
            increasingColor: "yellow"
            decreasingColor: "blue"
            Component.onCompleted:{
                chartView.parser(jsonStr);
                const w = space.width * (candleSeries.count /  20);
                space.contentWidth = w > space.width ? w : space.width;
            }


        }
        function groupToCandle(data, periodMinutes){
            const candles = [];
            const periodMs = periodMinutes * 60 * 1000;
            let currentCandle = null;
            for (var i = 0; i < data.time.length; i++){
                const time = new Date(data.time[i])
                const periodStart = new Date(Math.floor(time.getTime() / periodMs) * periodMs)
                if (!currentCandle || currentCandle.timestamp !== periodStart.getTime()){
                    if (currentCandle) candles.push(currentCandle);
                    currentCandle = {
                        timestamp: periodStart.getTime(),
                        open: data.temperature_2m[i],
                        close: data.temperature_2m[i],
                        high: data.temperature_2m[i],
                        low: data.temperature_2m[i]
                    }
                }
                else{
                    currentCandle.close = data.temperature_2m[i];
                    currentCandle.hight = Math.max(currentCandle.hight, data.temperature_2m[i]);
                    currentCandle.low = Math.min(currentCandle.low, data.temperature_2m[i]);
                }

            }
            if (currentCandle) candles.push(currentCandle);



            return candles;
        }


        function parser(json){
            try {
                var data = JSON.parse(json);
                const candles = groupToCandle(data.hourly, 24 * 60);
                var minX,minY,maxX,maxY;
                for (const candle of candles){
                    var candleSet = Qt.createQmlObject('import QtCharts 2.15; CandlestickSet {}', candleSeries);
                    candleSet.timestamp = candle.timestamp;
                    candleSet.open = candle.open;
                    candleSet.high = candle.high;
                    candleSet.low = candle.low;
                    candleSet.close = candle.close;
                    candleSeries.append(candleSet);
                    if (minX){
                        minX = Math.min(minX,candle.timestamp);
                        maxX = Math.max(maxX,candle.timestamp);
                        minY = Math.min(minY,candle.low);
                        maxY = Math.max(maxY,candle.high);
                    }
                    else {
                        minX = candle.timestamp;
                        maxX = candle.timestamp;
                        minY = candle.low;
                        maxY = candle.high;
                    }
                }
                aY.min = minY - 2;
                aY.max = maxY + 2;
                const paddingX = 40000000;
                aX.min = new Date(minX - paddingX);
                aX.max = new Date(maxX + paddingX);
                chartView.axisX(CandlestickSeries).min = minX;
                chartView.axisX(CandlestickSeries).max = maxX;
                chartView.axisY(CandlestickSeries).low = minY;
                chartView.axisY(CandlestickSeries).high = maxY;

            }
            catch(error) {
                console.error("JSON parsing error:", error);
            }

        }
    }

}
