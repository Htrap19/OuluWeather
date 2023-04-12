import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: overview_column

    RowLayout {
        id: temperature_row
        spacing: 10

        Image {
            id: temperature_image
            width: 48
            height: 48
            source: "qrc:/icons/images/temperature-high-solid.svg"
            sourceSize.height: 48
            sourceSize.width: 48
            fillMode: Image.PreserveAspectFit
        }

        Column {
            Row {
                spacing: 20
                Text {
                    id: highestTemperature_text
                    text: qsTr("-2.0 C")
                    font.pointSize: 20
                    color: "black"
                }

                Text {
                    id: temperatureDistance_text
                    text: qsTr("3.6 km from forecast location")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                id: temperatureStation_text
                text: "Oulu Vihreäsaari harbour"
                color: 'gray'
                wrapMode: Text.WordWrap
            }
        }
    }

    RowLayout {
        id: wind_row
        spacing: 10

        Image {
            id: wind_image
            width: 48
            height: 48
            source: "qrc:/icons/images/wind-solid.svg"
            sourceSize.height: 48
            sourceSize.width: 48
            fillMode: Image.PreserveAspectFit
        }

        Column {
            Row {
                spacing: 20
                Text {
                    id: strongestWind_text
                    text: qsTr("11 m/s")
                    font.pointSize: 20
                    color: "black"
                }

                Text {
                    id: windDistance_text
                    text: qsTr("34.8 km from forecast location")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                id: windStation_text
                text: "Hailuoto Keskikylä"
                color: 'gray'
                wrapMode: Text.WordWrap
            }
        }
    }

    RowLayout {
        id: pressure_row
        spacing: 10

        Image {
            id: pressure_image
            width: 48
            height: 48
            source: "qrc:/icons/images/weight-scale-solid.svg"
            sourceSize.height: 48
            sourceSize.width: 48
            fillMode: Image.PreserveAspectFit
        }

        Column {
            Row {
                spacing: 20
                Text {
                    id: lowestPressure_text
                    text: qsTr("1029.0 hPA")
                    font.pointSize: 20
                    color: "black"
                }

                Text {
                    id: pressureDistance_text
                    text: qsTr("40.6 km from forecast location")
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                id: pressureStation_text
                text: "Siikajoki Ruukki"
                color: 'gray'
                wrapMode: Text.WordWrap
            }
        }
    }
}
