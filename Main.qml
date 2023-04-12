import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Window {
    id: main_window
    width: 640
    height: 480
    visible: true
    title: qsTr("Oulu Weather")

    Material.accent: Material.Grey

    StackView {
        id: main_stackview
        anchors.fill: parent
        initialItem: Screen01 {
            id: screen01
        }
    }
}
