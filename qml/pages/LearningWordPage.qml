import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1


BaseWordPage {
    id: learningWord
    anchors.fill: parent
    Column{
        anchors.fill: parent
        Label{
            id: en
            font.pointSize: Theme.fontSizeExtraLarge
            height: parent.height / 4
            horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top
            }
        }
        IconButton{
            id: reveal
            icon.source: "image://theme/icon-l-add"

            onClicked:{
                ru.text = m_learning.get(0).ru
            }
            anchors{
                left: parent.left
                right: parent.right
                top: en.bottom
            }
        }

        Label{
            id: ru
            font.pointSize: Theme.fontSizeExtraLarge
            height: parent.height / 4
            horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"

            anchors{
                left: parent.left
                right: parent.right
                top: reveal.bottom
            }
        }
        GridLayout{
            id: btns1
            columns: 2
            rowSpacing: 20
            columnSpacing: 20

            anchors{
                left: parent.left
                right: parent.right
                top: ru.bottom
                leftMargin: 20
                rightMargin: 10
                bottom: parent.bottom
            }

            Button{
                id: fail
                //text: qsTr("Я не вспомнил слово")
                height: parent / 2
                Label{
                    text: qsTr("Я не вспомнил слово")
                    anchors.fill: parent
                    anchors.margins: 10
                    wrapMode: Text.WordWrap
                }

                onClicked:{
                    db.progressDown(m_learning.get(0).id)
                    m_learning.remove(0);
                    loadNextPage(m_marking, m_learning);
                }
            }
            Button{
                id: success
                text: qsTr("Я вспомнил слово")
                height: parent / 2
                onClicked: {
                    db.progressUp(m_learning.get(0).id)
                    m_learning.remove(0);
                    loadNextPage(m_marking, m_learning)
                }
            }
        }
    }

    Component.onCompleted: {
        pageTitle = "Изучение слова"
        learningWord.learningClicked.connect(onLearningButtonClicked)
        en.text = m_learning.get(0).en
    }


    function onLearningButtonClicked() {
        console.log("onLearningButtonClick");
        loadNextPage(m_marking, m_learning);
    }

}
