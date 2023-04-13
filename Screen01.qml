import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import Backend

Page {
    id: base_page

    function showIndicator(show: boolean) {
        base_indicator.running = show
        base_scrollview.enabled = !show
    }

    HighlightsBackend {
        id: base_highlightsbackend
        onHighestTemperatureChanged:
            base_page.highestTemperature = base_highlightsbackend.highestTemperature
        onStrongestWindChanged:
            base_page.strongestWind = base_highlightsbackend.strongestWind
        onLowestPressureChanged:
            base_page.lowestPressure = base_highlightsbackend.lowestPressure

        onAllFinished:
            showIndicator(false)
    }

    property var highestTemperature: base_highlightsbackend.highestTemperature
    property var strongestWind: base_highlightsbackend.strongestWind
    property var lowestPressure: base_highlightsbackend.lowestPressure

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

            BusyIndicator {
                id: base_indicator
                running: false
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
                onActivated: {
                    showIndicator(true)
                    base_highlightsbackend.fetchStations(currentIndex)
                }
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
//        contentWidth: base_columnlayout.width
//        contentHeight: base_columnlayout.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.interactive: true

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
                    Layout.fillWidth: true
                    Layout.columnSpan: parent.columns
                    model: base_highlightsbackend.stations
                    onActivated: {
                        base_highlightsbackend.onActivated(currentIndex)
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: qsTr("Temperature:")
                }
                Text {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: "%1 C".arg((base_highlightsbackend.selectedStation ?? { temperature: "-" }).temperature)
                }

                Text { text: qsTr("Humidity:") }
                Text { text: "%1 %".arg((base_highlightsbackend.selectedStation ?? { humidity: "-" }).humidity) }

                Text { text: qsTr("Visibility:") }
                Text { text: "over %1 km".arg((base_highlightsbackend.selectedStation ?? { visibility: 0 }).visibility / 1000.0) }

                Text {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: qsTr("Dewpoint:")
                }
                Text { text: "%1 C".arg((base_highlightsbackend.selectedStation ?? { dewPoint: "-" }).dewPoint) }

                Text { text: qsTr("Wind:") }
                Text { text: "%1 m/s".arg((base_highlightsbackend.selectedStation ?? { windSpeedMS: "-" }).windSpeedMS) }

                Text { text: qsTr("Wind gusts:") }
                Text { text: "%1 m/s".arg((base_highlightsbackend.selectedStation ?? { windGust: "-" } ).windGust) }

                Text { text: qsTr("Pressure:") }
                Text { text: "%1 hPa".arg((base_highlightsbackend.selectedStation ?? { pressure: "-" }).pressure) }
            }
        }
    }

    Component.onCompleted: {
        showIndicator(true)
        base_highlightsbackend.fetchStations()
    }
}
