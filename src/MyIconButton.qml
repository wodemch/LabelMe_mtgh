import QtQuick 2.0

Rectangle {
    id: rec

    property alias img_src: icon.source
    property alias text: button.text

    property color clr_enter: "#dcdcdc"
    property color clr_exit: "#ffffff"
    property color clr_click: "#aba9b2"
    property color clr_release: "#ffffff"

    //自定义点击信号
    signal clickedLeft()
    signal clickedRight()
    signal release()

    Image {
        id: icon
        width: parent.width
        height: parent.height-20
        source: ""
        fillMode: Image.PreserveAspectFit
        clip: true
    }

    Text {
        id: button
        text: qsTr("no set")

        anchors.top: icon.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter: icon.horizontalCenter
        anchors.bottom: icon.bottom
        anchors.bottomMargin: 2
        font.pointSize: 11
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        //接受左键和右键输入
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            //左键点击
            if (mouse.button === Qt.LeftButton)
            {
                parent.clickedLeft()
                //                console.log(button.text + " Left button click")
            }
            else if(mouse.button === Qt.RightButton)
            {
                parent.clickedRight()
                //                console.log(button.text + " Right button click")
            }
        }

        //按下
        onPressed: {
            color = clr_click
        }

        //释放
        onReleased: {
            color = clr_enter
            parent.release()
            //console.log("Release")
        }

        //指针进入
        onEntered: {
            color = clr_enter
            //            console.log(button.text + " mouse entered")
        }

        //指针退出
        onExited: {
            color = clr_exit
            //            console.log(button.text + " mouse exited")
        }
    }
}
