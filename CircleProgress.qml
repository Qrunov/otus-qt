import QtQuick 2.15
import QtQuick.Window 2.15
import qmlcircleprogress 1.0
import QtQuick.Controls 2.15


QQmlCircleProgress{
    id: circlePB
    ProgressBar{
        id: progressBar_logic
        visible: false
    }

    property alias from: progressBar_logic.from
    property alias to: progressBar_logic.to
    property alias value: progressBar_logic.value
    property alias position: progressBar_logic.position
    Connections{
        target: progressBar_logic
        onValueChanged: {
            circlePB.onUpdate();
        }
    }
}

