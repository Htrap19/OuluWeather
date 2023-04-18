import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import Backend

Page {
    id: base_page

    property var highestTemperature: base_highlightsbackend.highestTemperature()
    property var strongestWind: base_highlightsbackend.strongestWind()
    property var lowestPressure: base_highlightsbackend.lowestPressure()

    function showIndicator(show: boolean) {
        base_indicator.running = show
        base_scrollview.enabled = !show
    }

    function validateValue(value) {
        if (base_highlightsbackend.selectedStation == null ||
            base_highlightsbackend.selectedStation == undefined ||
            value === 2000) // TODO: grab invalid value from backend(c++)
            return "-";

        return value;
    }

    HighlightsBackend {
        id: base_highlightsbackend

        onAllFinished: {
            showIndicator(false)
            base_page.highestTemperature = base_highlightsbackend.highestTemperature()
            base_page.strongestWind = base_highlightsbackend.strongestWind()
            base_page.lowestPressure = base_highlightsbackend.lowestPressure()
        }
    }

    header: ToolBar {
        Material.foreground: "white"
        RowLayout {
            spacing: 20
            anchors {
                fill: parent
                rightMargin: 5
            }

            BusyIndicator {
                id: base_indicator
                running: false
                Material.accent: "white"
            }

            Label {
                text: qsTr("Highlights")
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ComboBox {
                model: base_highlightsbackend.cities
                onActivated: {
                    showIndicator(true)
                    base_highlightsbackend.fetchStations(currentIndex)
                }
                Material.foreground: "white"
            }
        }
    }

    footer: ToolBar {
        Material.foreground: "white"
        RowLayout {
            anchors.fill: parent
            Label {
                text: qsTr("Powered by Ilmatieteenlaitos Api")
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }

    ScrollView {
        id: base_scrollview
        anchors.fill: parent
        contentWidth: base_columnlayout.width
        contentHeight: base_columnlayout.Height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        bottomPadding: 20

        ColumnLayout {
            id: base_columnlayout
            width: Math.max(implicitWidth, base_scrollview.availableWidth)
            height: Math.max(implicitHeight, base_scrollview.availableHeight)

            HighlightsSwipe {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }

//            Highlights {
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
//            }

            GridLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: parent.width > parent.height ? 4 : 2
                columnSpacing: 20
                rowSpacing: 10

                Label {
                    text: qsTr("Stations")
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                }

                ComboBox {
                    Layout.fillWidth: true
                    Layout.columnSpan: parent.columns
                    model: base_highlightsbackend.stations
                    onActivated:
                        base_highlightsbackend.onActivated(currentIndex)
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: qsTr("Temperature:")
                }
                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: "%1 \u2103".arg(validateValue(base_highlightsbackend.selectedStation?.temperature))
                }

                Label { text: qsTr("Humidity:") }
                Label { text: "%1 %".arg(validateValue(base_highlightsbackend.selectedStation?.humidity)) }

                Label { text: qsTr("Visibility:") }
                Label { text: "over %1 km".arg(validateValue(base_highlightsbackend.selectedStation?.visibility) === "-" ?
                                                   "-" :
                                                   base_highlightsbackend.selectedStation.visibility / 1000.0) }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: qsTr("Dewpoint:")
                }
                Label { text: "%1 \u2103".arg(validateValue(base_highlightsbackend.selectedStation?.dewPoint)) }

                Label { text: qsTr("Wind:") }
                Label { text: "%1 m/s".arg(validateValue(base_highlightsbackend.selectedStation?.windSpeedMS)) }

                Label { text: qsTr("Wind gusts:") }
                Label { text: "%1 m/s".arg(validateValue(base_highlightsbackend.selectedStation?.windGust)) }

                Label { text: qsTr("Pressure:") }
                Label { text: "%1 hPa".arg(validateValue(base_highlightsbackend.selectedStation?.pressure)) }
            }
        }
    }

    Component.onCompleted: {
        showIndicator(true)
        base_highlightsbackend.fetchStations()
    }
}
