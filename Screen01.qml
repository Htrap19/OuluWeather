import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import Backend

Page {
    id: base_page

    HighlightsBackend {
        id: base_highlightsbackend
    }

    header: ToolBar {
        background: Rectangle {
            implicitHeight: 40
            color: "#426731"
        }

        RowLayout {
            anchors {
                fill: parent
                rightMargin: 5
            }

            Label {
                text: qsTr("Highlights")
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: "white"
            }

            ComboBox {
                Material.foreground: "white"
                model: base_highlightsbackend.cities
                onActivated: base_highlightsbackend.fetchStations(currentIndex)
            }
        }
    }

    footer: ToolBar {
        background: Rectangle {
            implicitHeight: 20
            color: "#426731"
        }

        RowLayout {
            anchors.fill: parent
            Label {
                text: qsTr("Powered by Ilmatieteenlaitos Api")
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: "white"
            }
        }
    }

    ScrollView {
        id: base_scrollview
        anchors.fill: parent
        contentWidth: base_columnlayout.width
        contentHeight: base_columnlayout.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ColumnLayout {
            id: base_columnlayout
            width: Math.max(implicitWidth, base_scrollview.availableWidth)
            height: Math.max(implicitHeight, base_scrollview.availableHeight)

            Highlights {
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

            GridLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: parent.width > parent.height ? 4 : 2
                columnSpacing: 20
                rowSpacing: 10

                Text {
                    text: qsTr("Stations")
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                }

                ComboBox {
                    Layout.fillWidth: parent.width < parent.height
                    Layout.columnSpan: 2
                    model: base_highlightsbackend.stations
                }

                Text {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: qsTr("Temperature:")
                }
                Text {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: "-2.0 C"
                }

                Text { text: qsTr("Humidity:") }
                Text { text: "60%" }

                Text { text: qsTr("Visibility:") }
                Text { text: "over 20 km" }

                Text {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: qsTr("Dewpoint:")
                }
                Text { text: "-1.4 C" }

                Text { text: qsTr("Wind:") }
                Text { text: "5 m/s" }

                Text { text: qsTr("Wind guests:") }
                Text { text: "6 m/s" }

                Text { text: qsTr("Pressure:") }
                Text { text: "1032.2 hPA" }
            }
        }
    }

    Component.onCompleted: {
        base_highlightsbackend.fetchStations()
    }
}
