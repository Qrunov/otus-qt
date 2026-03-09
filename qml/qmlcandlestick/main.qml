import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    StackView{
        id: stackView
        anchors.fill: parent
        initialItem: "option.qml"
    }
}
