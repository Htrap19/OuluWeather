import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: main_window
    width: 720
    height: 640
    visible: true
    title: qsTr("Oulu Weather")

    StackView {
        id: main_stackview
        anchors.fill: parent
        initialItem: Screen01 {
            id: screen01
        }
    }
}
