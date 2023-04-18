import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    contentWidth: highlights_swipeview.implicitWidth
                  + highlights_pageindicator.implicitWidth
    contentHeight: highlights_swipeview.implicitHeight
                   + highlights_pageindicator.implicitHeight

    SwipeView {
        id: highlights_swipeview
        anchors.fill: parent
        currentIndex: 1

        Item {
            id: temperature_item

            Image {
                id: temperature_image
                source: "qrc:/icons/images/temperature-high-solid.svg"
                sourceSize.height: 48
                sourceSize.width: 48
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }

            Label {
                id: temperature_label
                text: "%1 \u2103".arg((highestTemperature ?? { temperature: "-" }).temperature)
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 20
                anchors {
                    top: temperature_image.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                id: temperatureStation_label
                text: "%1, %2 km from forecast location"
                    .arg((highestTemperature ?? { name: "-" }).name)
                    .arg((highestTemperature ?? { distance: "-" }).distance)
                color: 'gray'
                wrapMode: Text.WordWrap
                anchors {
                    top: temperature_label.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Item {
            id: wind_item

            Image {
                id: wind_image
                source: "qrc:/icons/images/wind-solid.svg"
                sourceSize.height: 48
                sourceSize.width: 48
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }

            Label {
                id: strongestWind_label
                text: "%1 m/s".arg((strongestWind ?? { windSpeedMS: "-" }).windSpeedMS)
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 20
                anchors {
                    top: wind_image.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                id: windStation_label
                text: "%1, %2 km from forecast location"
                    .arg((strongestWind ?? { name: "-" }).name)
                    .arg((strongestWind ?? { distance: "-" }).distance)
                color: 'gray'
                wrapMode: Text.WordWrap
                anchors {
                    top: strongestWind_label.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Item {
            id: pressure_item

            Image {
                id: pressure_image
                source: "qrc:/icons/images/weight-scale-solid.svg"
                sourceSize.height: 48
                sourceSize.width: 48
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }

            Label {
                id: lowestPressure_label
                text: "%1 hPa".arg((lowestPressure ?? { pressure: "-" }).pressure)
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 20
                anchors {
                    top: pressure_image.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                id: pressureStation_label
                text: "%1, %2 km from forecast location"
                    .arg((lowestPressure ?? { name: "-" }).name)
                    .arg((lowestPressure ?? { distance: "-" }).distance)
                color: 'gray'
                wrapMode: Text.WordWrap
                anchors {
                    top: lowestPressure_label.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    PageIndicator {
        id: highlights_pageindicator

        count: highlights_swipeview.count
        currentIndex: highlights_swipeview.currentIndex
        anchors {
            top: highlights_swipeview.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }
}
