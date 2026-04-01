import QtQuick 2.6
import Sailfish.Silica 1.0

import QtPositioning 5.3
import QtLocation 5.0
import "../assets"

Page {
    property var coord
    PositionSource {
        id: positionSource
        updateInterval: 1000
//        nmeaSource: "../../nmea/path.nmea"
        nmeaSource: "/usr/share/ru.auroraos.PositioningAndLocation/nmea/path.nmea"
//        active: activeSwitch.checked
        active: true

    }
    Map {
        id: map
        anchors.fill: parent

        // ToDo: define plugin to work with OSM
        Plugin {
            id: mapPlugin
            objectName: "mapPlugin"
            name: "webtiles"
            allowExperimental: false
            PluginParameter { name: "webtiles.scheme"; value: "https" }
            PluginParameter { name: "webtiles.host";
                value: "tile.openstreetmap.org" }
            PluginParameter { name: "webtiles.path";
                value: "/${z}/${x}/${y}.png" }
        }
        plugin: mapPlugin
        // ToDo: enable gesture recognition
        gesture.enabled: true
        gesture.activeGestures: MapGestureArea.FlickGesture | MapGestureArea.PanGesture | MapGestureArea.PinchGesture
        // ToDo: add binding of the map center to the position coordinate
        zoomLevel: slider.value  // Привязка к слайдеру
        minimumZoomLevel: 1
        maximumZoomLevel: 20
        // ToDo: create MouseArea to handle clicks and holds
        // Обработчик кликов
        // MouseArea {
        //     anchors.fill: parent
        //     id: ma
        //     // ToDo: add item at the current position
        //     onClicked: {
        //         // Преобразуем экранные координаты в географические
        //         var coord = map.toCoordinate(Qt.point(mouse.x, mouse.y))
        //         fp.coordinate = coord
        //     }
        // }
        onCenterChanged:{
            fp.diameter = Math.min(map.width, map.height) / 8
        }

        Component.onCompleted: {
            //center = QtPositioning.coordinate(55.751244, 37.618423)
            //center = QtPositioning.coordinate(positionSource.position.coordinate.latitude,positionSource.position.coordinate.longitude)
            addMapItem(fp)
            fp.diameter = Math.min(map.width, map.height) / 8
            fp.visible = true
        }
        onZoomLevelChanged: {
            //center = QtPositioning.coordinate(positionSource.position.coordinate.latitude,positionSource.position.coordinate.longitude)
            fp.diameter = Math.min(map.width, map.height) / 8
        }

    }
    // ToDo: add a slider to control zoom level
    Slider {
        id: slider
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 20
        }
        value: 11  // Начальное значение зума
        minimumValue: 1
        maximumValue: 19
        visible: true
        stepSize: 1
    }
    // Timer{
    //     interval: 1000
    //     repeat: false
    //     running: true
    //     onTriggered: {
    //         console.log("triggered ")
    //         fp.diameter = Math.min(map.width, map.height) / 8
    //     }
    // }

    Binding {
      target: map
      property: "center"
      value: positionSource.position.coordinate
      when: positionSource.position.coordinate.isValid
    }

    Footprints {
        id: fp
        //coordinate: positionSource.position.coordinate
        visible: false
    }

    Binding {
      target: fp
      property: "coordinate"
      value: positionSource.position.coordinate
      when: positionSource.position.coordinate.isValid
    }


    // ToDo: add a component corresponding to MapQuickCircle



}
