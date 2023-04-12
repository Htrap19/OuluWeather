import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

GridLayout {
    id: base_gridlayout
//    columnSpacing: 10
//    rowSpacing: 10
    flow: width > height ? GridLayout.LeftToRight : GridLayout.TopToBottom

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
            Text {
                id: highestTemperature_text
                text: qsTr("-2.0 C")
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 20
                color: "black"
            }

            Label {
                id: temperatureDistance_text
                color: "#808080"
                text: qsTr("3.6 km")
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                elide: Label.ElideRight
            }
        }

        Text {
            id: temperatureStation_text
            text: "Oulu Vihreäsaari harbour"
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
            Text {
                id: strongestWind_text
                text: qsTr("10 m/s")
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 20
                color: "black"
            }

            Label {
                id: windDistance_text
                color: "#808080"
                text: qsTr("34.8 km")
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                elide: Label.ElideRight
            }
        }

        Text {
            id: windStation_text
            text: "Hailuoto Keskikylä"
            color: 'gray'
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

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
            Text {
                id: lowestPressure_text
                text: qsTr("1029.7 hPA")
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 20
                color: "black"
            }

            Label {
                id: pressureDistance_text
                color: "#808080"
                text: qsTr("40.6 km")
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                elide: Label.ElideRight
            }
        }

        Text {
            id: pressureStation_text
            text: "Siikajoki Ruukki"
            color: 'gray'
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
