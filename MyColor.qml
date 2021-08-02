import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
Window {
    id: window
    visible: true
    width: 300;
    height: 200;
    property alias showColor: helloText.color;

    signal colorModify(color selectColor)
    Rectangle {
        id:content
        color: 'lightgray'
        anchors.fill: parent

        ColumnLayout{
            spacing: 5
            anchors.fill: parent
            Layout.alignment: Qt.AlignCenter
            Text{
                id: helloText;
                text: "hello world!";
                y:30;
                Layout.alignment: Qt.AlignCenter
                font.pointSize: 24;
                font.bold: true;
            }

            Grid {
                id: colorPicker;
                x:4;
                Layout.alignment: Qt.AlignCenter
                rows:2;
                columns: 3;
                spacing: 3;

                Cell { cellColor: 'red'; onClicked: helloText.color = cellColor; }
                Cell { cellColor: 'green'; onClicked: helloText.color = cellColor; }
                Cell { cellColor: 'blue'; onClicked: helloText.color = cellColor; }
                Cell { cellColor: 'yellow'; onClicked: helloText.color = cellColor; }
                Cell { cellColor: 'steelblue'; onClicked: helloText.color = cellColor; }
                Cell { cellColor: 'black'; onClicked: helloText.color = cellColor; }
            }
            RowLayout{
                spacing: 50
                Layout.alignment: Qt.AlignCenter
                Button{
                    id:canceled
                    text: qsTr("取消")
                    onClicked: {close();}
                }
                Button{
                    id:ok
                    text: qsTr("应用")
                    onClicked: {                        
                        window.colorModify(showColor)
                        close()
                    }
                }
            }
        }
    }
}
