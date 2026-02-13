import QtQuick 2.15
import QtQuick.Window 2.15
import qmlcircleprogress 1.0
import QtQuick.Controls 2.15




Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("QML circle progress bar")

    CircleProgress{
        id: cc
        anchors.fill: parent
        value: 0
        Component.onCompleted: value = 1
    }

    NumberAnimation {
        id: valueAnimation
        target: cc
        property: "value"
        from: 0
        to: 1
        duration: 20000
        running: true
    }
}
