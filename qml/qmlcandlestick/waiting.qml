import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

Page {
    property string longitude
    property string latitude
    property string start
    property string end
    property string query: `https://archive-api.open-meteo.com/v1/era5?latitude=${latitude}&longitude=${longitude}&start_date=${start}&end_date=${end}&hourly=temperature_2m`
    property var xhr

    id: waiting

    Connections {
        target: networkHandler
        function onProcessingFinished(result) {
            //            console.log("rensponse received:",result);
            if (result !== ""){
                stackView.push("chart.qml",{jsonStr: result})
            }
            else{
                stackView.pop(stackView.get(0))
            }

        }
    }



    Component.onCompleted:{
        var result = networkHandler.processStringAsync(query)
    }
    
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Label {
            text: qsTr("Выполняется запрос данных. Ждите...");
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
        }

        ProgressBar{
            Layout.fillWidth: true
            Layout.leftMargin: 50
            Layout.rightMargin: 50
            indeterminate: true
        }

        Button {
            id: submit
            text: "Отмена"

            onClicked: {
                stackView.pop(stackView.get(0))
            }
        }

    }

}
