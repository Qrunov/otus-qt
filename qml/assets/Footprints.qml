import QtQuick 2.6
import QtLocation 5.0
MapQuickItem {
    property alias diameter: image.width
    sourceItem: Image {
        id: image
        source: Qt.resolvedUrl("../graphics/footprints.svg")
        //source: "image://theme/icon-m-location"  // стандартная иконка геолокации
        width: objectSize
        height: width
        fillMode: Image.PreserveAspectFit
    }
    anchorPoint {
        x: sourceItem.width / 2
        y: sourceItem.height / 2
    }
}
