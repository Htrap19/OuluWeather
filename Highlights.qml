import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    Layout.fillHeight: false
    Layout.fillWidth: true

    RowLayout {
        id: first_rowlayout
        Layout.fillWidth: true

        Column {
            id: temperature_column
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            padding: 10
            spacing: 5

            Image {
                id: temperature_image
                source: "qrc:/icons/images/temperature-high-solid.svg"
                sourceSize.height: 48
                sourceSize.width: 48
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RowLayout {
                Layout.fillWidth: true
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: highestTemperature_text
                    text: "%1 \u2103".arg((highestTemperature ?? { temperature: "-" }).temperature)
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pointSize: 20
                }

                Label {
                    id: temperatureDistance_text
                    color: "#808080"
                    text: "%1 km".arg((highestTemperature ?? { distance: "-" }).distance)
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    elide: Label.ElideRight
                }
            }

            Label {
                id: temperatureStation_text
                text: ((highestTemperature ?? { name: "-" }).name)
                color: 'gray'
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            id: wind_column
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            padding: 10
            spacing: 5

            Image {
                id: wind_image
                source: "qrc:/icons/images/wind-solid.svg"
                sourceSize.height: 48
                sourceSize.width: 48
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RowLayout {
                Layout.fillWidth: true
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    id: strongestWind_text
                    text: "%1 m/s".arg((strongestWind ?? { windSpeedMS: "-" }).windSpeedMS)
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pointSize: 20
                }

                Label {
                    id: windDistance_text
                    color: "#808080"
                    text: "%1 km".arg((strongestWind ?? { distance: "-" }).distance)
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    elide: Label.ElideRight
                }
            }

            Label {
                id: windStation_text
                text: ((strongestWind ?? { name: "-" }).name)
                color: 'gray'
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    RowLayout {
        id: second_rowlayout
        Layout.fillWidth: true

        Column {
            id: pressure_column
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            padding: 10
            spacing: 5

            Image {
                id: pressure_image
                source: "qrc:/icons/images/weight-scale-solid.svg"
                sourceSize.height: 48
                sourceSize.width: 48
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RowLayout {
                Layout.fillWidth: true
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    id: lowestPressure_text
                    text: "%1 hPa".arg((lowestPressure ?? { pressure: "-" }).pressure)
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pointSize: 20
                }

                Label {
                    id: pressureDistance_text
                    color: "#808080"
                    text: "%1 km".arg((lowestPressure ?? { distance: "-" }).distance)
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignRight
                    verticalAlignment: Qt.AlignVCenter
                    elide: Label.ElideRight
                }
            }

            Label {
                id: pressureStation_text
                text: ((lowestPressure ?? { name: "-" }).name)
                color: 'gray'
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
