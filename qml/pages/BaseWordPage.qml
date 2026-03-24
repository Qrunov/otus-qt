import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: word
    objectName: "base"
    default property alias content: contentArea.data
    property string pageTitle: "Заголовок"

    property var m_marking: ListModel
    property var m_learning: ListModel

    property bool m_isMarking: true
    property bool m_isLearning: true

    signal markingClicked()
    signal learningClicked()

    PageHeader {
        title: qsTr(pageTitle)
        id: pageHdr
        extraContent.children: [
            Row{
                IconButton {
                    id: marking
                    property bool isToggled: true
                    icon.source: "image://theme/icon-m-edit"
                    //                    anchors.verticalCenter: parent.verticalCenter
                    onClicked:{
                        isToggled = !isToggled;
                        markingClicked();
                    }
                    enabled: true
                    icon.color: isToggled ? Theme.highlightColor : Theme.primaryColor
               }
                IconButton {
                    id: learning
                    property bool isToggled: true
                    icon.source: "image://theme/icon-m-search"
                    //                    anchors.verticalCenter: parent.verticalCenter
                    onClicked:{
                        isToggled = !isToggled;
                        learningClicked();
                    }
                    enabled: true
                    icon.color: isToggled ? Theme.highlightColor : Theme.primaryColor
                }
            }
        ]
    }

    function replacePage(url, u, l){
        if (pageStack.depth > 1)
            pageStack.replace(Qt.resolvedUrl(url), {m_marking: u, m_learning: l, m_isMarking: marking.isToggled, m_isLearning: learning.isToggled});
        else
            pageStack.push(Qt.resolvedUrl(url), {m_marking: u, m_learning: l, m_isMarking: true, m_isLearning: true});
    }


    function loadNextPage(u, l)
    {
        var nextPage = "";
        console.log(marking.enabled, pageStack.depth, u.count)
        if ((marking.isToggled || pageStack.depth === 1) && u.count > 0)
        {
            nextPage = "MarkingWordPage.qml";
        }
        else if ((learning.isToggled || pageStack.depth === 1) && l.count > 0)
            nextPage = "LearningWordPage.qml";
        else
        {
            pageStack.pop();
            return;
        }
        replacePage(nextPage, u, l);
    }

    Component.onCompleted: {
        console.log("base Component.onCompleted");
        marking.enabled = (m_marking.count > 0);
        marking.isToggled = (marking.enabled && m_isMarking);
        learning.enabled = (m_learning.count > 0);
        learning.isToggled = (learning.enabled && m_isLearning);
    }

    Item {
        id: contentArea
        anchors {
            top: pageHdr.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }
}
