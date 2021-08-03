import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import Qt.labs.folderlistmodel 2.12
import QtQuick.XmlListModel 2.0
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.1
import Test.MainView 1.0
Window {
    visible: true
    id:rootWin
    property int winWidth: 1500
    property int winHeight: 800
    property int col1Width: 100
    property int col2Width: 980
    property int col3Width: 400
    property int labelViewHeight: 300
    property int fileViewHeight: 400
    property int imageViewHeight: 770
    property int fontSize: 12
    property int edgeMargin: 2
    property double resetScale:1
    property bool enableCircle:true
    property bool firstEnter:true

    width: winWidth
    height: winHeight
    //maximumWidth: winWidth
    //maximumHeight: winHeight
    minimumWidth: winWidth
    minimumHeight: winHeight
    x:220
    y:50
    title: qsTr("LabelMe_mtgh")

    onWidthChanged: {
        col2Width = width - col1Width-col3Width-15
        col3.x = col1Width + col2Width + 10
    }
    onHeightChanged: {
        //fileViewHeight = height-labelViewHeight-90
        imageViewHeight = height-30

    }

    property string flagFilePath: appDir+"/config/flag.xml"

    XmlListModel {
        id: flagModel
        source: "file:///"+flagFilePath
        query: "/rss/type"

        XmlRole { name: "name"; query: "name/string()" }
    }
    Component{
        id: labelDelegate
        Rectangle {
            width: ListView.view.width
            height: 20
            color: ListView.isCurrentItem?"darkgray":"white" //选中颜色设置
            border.color: Qt.lighter(color, 1.1)
            Text {
                text: name
                font.pointSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: m_LabelView.currentIndex = index  //实现item切换
            }
        }
    }
    Component{
        id: labelNameDelegate
        Rectangle {
            width: ListView.view.width
            height: 20
            color: ListView.isCurrentItem?"darkgray":"white" //选中颜色设置
            border.color: Qt.lighter(color, 1.1)
            Text {
                text: name
                font.pointSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: m_Labelname.currentIndex = index  //实现item切换
            }
        }
    }
    Component{
        id: rectDelegate
        Rectangle {
            width: ListView.view.width
            height: 20
            color: ListView.isCurrentItem?"darkgray":"white" //选中颜色设置
            border.color: Qt.lighter(color, 1.1)
            Text {
                text: name
                font.pointSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: m_RectView.currentIndex = index  //实现item切换
            }
        }
    }
    Component{
        id: fileDelegate
        Rectangle {
            width: ListView.view.width
            height: 20
            color: ListView.isCurrentItem?"darkgray":"white" //选中颜色设置
            border.color: Qt.lighter(color, 1.1)
            Text {
                text: title + ":"+pubDate
                font.pointSize: fontSize
            }
            MouseArea {
                anchors.fill: parent
                onClicked: m_FileView.currentIndex = index  //实现item切换
            }
        }
    }

    MyPopup{
        id:myp
        parent: parent
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    MyLabelNameInput{
        id:lebelInputer
        parent: parent
        width: 360
        height: 400
        x:(parent.width-width)/2
        y:(parent.height-height)/2
        closePolicy: Popup.NoAutoClose//禁止Esc键退出

        onOkClose: {
            mainview.modifyLabelName(val)
        }
    }

    function showMsgBox(info)
    {
        myp.tipText =info
        myp.open()
    }

    function buttonEnable(type)
    {
        switch(type)
        {
        case 0:
            createRect.enabled = false
            createpolygon.enabled = true
            createCircle.enabled = true&enableCircle
            break;
        case 1:
            createRect.enabled = true
            createpolygon.enabled = false
            createCircle.enabled = true&enableCircle
            break;
        case 2:
            createRect.enabled = true
            createpolygon.enabled = true
            createCircle.enabled = false&enableCircle
            break;
        }
    }


    FileDialog{
        id:fileDlg
        title: qsTr("Please choose image files")
        //selectExisting: true
        //selectMultiple: false
        folder: "file:///" + "E:/111" //shortcuts.pictures
        nameFilters: [qsTr("JPEG (*.jpg)"),qsTr("Bitmap (*.bmp)")]
        onAccepted: {
            folderList.folder = fileDlg.folder
        }
    }


    ColumnLayout{
        spacing: 0
        height: parent.height
        RowLayout{
            spacing: 5
            height: parent.height-30
            Layout.alignment: Qt.AlignTop
            ColumnLayout{
                width: col1Width
                spacing: 10
                height: parent.height
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.preferredWidth: col1Width
                MyIconButton {
                    id: open
                    img_src: "/res/open.png";
                    text: qsTr("打开目录")
                    width: 100
                    height: 50
                    onClickedLeft: {
                        fileDlg.open()
                        enableCircle = false
                    }
                }
                MyIconButton{
                    id: save
                    img_src: "/res/save.png"
                    text: qsTr("保存")
                    width: 100
                    height: 50
                    onClickedLeft: {
                        mainview.doSomething(MainView.TYPE_SAVE)
                    }
                }
                MyIconButton{
                    id: deletePage
                    img_src: "/res/delete.png"
                    text: qsTr("删除")
                    width: 100
                    height: 50
                    onClickedLeft: {
                        showMsgBox("是否删除:"+m_FileView.getCurrentImagePath())

                    }
                    Connections{
                        target: myp
                        onButtonOKClicked: {
                            var url = m_FileView.getCurrentImagePath()
                            mainview.deleteFile(url)
                        }
                        onButtonCancelClicked: {
                            console.log("取消删除:",m_FileView.getCurrentImagePath())
                        }
                    }
                }
                MyIconButton{
                    id: lastPage
                    img_src: "/res/last.png"
                    text: qsTr("上一张")
                    width: 100
                    height: 50
                    onClickedLeft: {
                        m_FileView.currentIndex -= m_FileView.currentIndex>0?1:0
                    }
                }
                MyIconButton{
                    id: nextPage
                    img_src: "/res/next.png"
                    text: qsTr("下一张")
                    width: 100
                    height: 50
                    onClickedLeft: {
                        m_FileView.currentIndex += m_FileView.currentIndex<m_FileView.count-1?1:0
                    }
                }
                MyLine{
                    id:line
                    width: parent.width
                    color: "darkgray"
                }
                Button{
                    id: createRect
                    text: qsTr("创建矩形")
                    width: 50
                    onClicked: {
                        mainview.doSomething(MainView.TYPE_RECT)
                        buttonEnable(0)
                    }
                }
                Button{
                    id: createpolygon
                    text: qsTr("创建多边形")
                    width: 50
                    onClicked: {
                        mainview.doSomething(MainView.TYPE_POLYGON)
                        buttonEnable(1)
                    }
                }
                Button{
                    id: createCircle
                    text: qsTr("创建圆形")
                    width: 50
                    onClicked: {
                        mainview.doSomething(MainView.TYPE_CIRCLE)
                        buttonEnable(2)
                    }
                }
                MyLine{
                    id:line2
                    width: parent.width
                    color: "darkgray"
                }
                Button{
                    id: deleteAll
                    text: qsTr("删除所有")
                    width: 50
                    onClicked: {
                        if(mainview.doSomething(MainView.TYPE_CLEAR)){
                            m_RectView.clearAll()
                        }
                    }
                }
                Button{
                    id: reset
                    text: qsTr("缩放重置")
                    width: 50
                    onClicked: {

                        mainview.changeScale(0)
                        //console.log("缩放重置W"+mainview.width+" "+ mainview.ImgWidth)
                        //console.log("缩放重置H"+mainview.height+" "+ mainview.ImgHeight)
                        var wS = mainview.width / mainview.ImgSize.width
                        var hS = mainview.height / mainview.ImgSize.height
                        resetScale =  wS>hS?hS:wS
                        mainview.scale = resetScale
                        mainview.x=mainview.width/2-mainview.ImgSize.width/2
                        mainview.y=mainview.height/2-mainview.ImgSize.height/2
                    }
                }
                Button{
                    id: showParms
                    text: qsTr("参数配置")
                    width: 50
                    onClicked: {
                        mainview.doSomething(MainView.TYPE_MODIFY)
                    }
                }
            }
            Rectangle {
                id: mapItemArea
                width: col2Width
                height: imageViewHeight
                anchors.centerIn: parent.Center
                color: "gray"
                clip: true
                MainView{
                    id: mainview
                    width: parent.width
                    height: parent.height
                    Connections {
                        target: mainview
                        onShowSelectLabelName:{
                            if(firstEnter){
                                firstEnter= false
                                lebelInputer.clearAll()
                                var listNmae = mainview.getLabelNameList()
                                for (var i = 0; i < listNmae.length; i++){
                                    lebelInputer.initAddOne(listNmae[i])
                                }
                            }

                            lebelInputer.open()
                        }
                    }
                    Connections {
                        target: mainview
                        onAddLabelName:{
                            m_RectView.addOne(index,labelName)
                        }
                    }
                    Connections {
                        target: mainview
                        onDeleteLabelName:{
                            m_RectView.deleteOne(index,labelName)
                        }
                    }
                    MouseArea {
                        id: msArea
                        anchors.fill: mainview
                        drag.target: mainview
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true //非按下状态 onPositionChanged

                        onClicked: {
                            //console.log("onClicked "+ pressedButtons + " "+pressed)
                            //mainview.mouseEnevt(pressedButtons,pressed,mouseX,mouseY)
                        }
                        onPressed:{
                            //console.log("onPressed "+pressedButtons+ " "+pressed)
                            mainview.mouseEnevt(pressedButtons,pressed,mouseX,mouseY)
                        }
                        onPositionChanged:{
                            //console.log("onPositionChanged x:"+mouseX+" y:"+mouseY+ " scale:"+mainview.scale)
                            //mainview.initPainter(mainview.width,mainview.height)
                            mainview.mouseMove(pressedButtons,pressed,mouseX,mouseY)
                            stateText.text = "Pos:"+mouseX.toFixed(0)+","+mouseY.toFixed(0)
                        }
                        //使用鼠标滚轮缩放
                        onWheel: {
                            var datla = wheel.angleDelta.y / 120
                            if (datla > 0)
                                mainview.scale = mainview.scale / 0.9
                            else
                                mainview.scale = mainview.scale * 0.9

                            mainview.changeScale(mainview.scale)
                        }
                    }
                }
            }
            Item {
                id: col3
                x:col2Width+col1Width+10
                ColumnLayout{
                    width: col3Width
                    spacing: 0
                    Layout.alignment: Qt.AlignTop
                    GroupBox{
                        visible: false
                        title: qsTr("标签列表")
                        width: parent.width
                        font.pointSize: fontSize
                        ColumnLayout{
                            anchors.fill: parent
                            ListView {
                                id: m_LabelView
                                width: parent.width
                                height: 200
                                model: flagModel
                                delegate: labelDelegate
                            }
                        }
                    }
                    GroupBox{
                        title: qsTr("标注列表 (双击可删除)")
                        width: parent.width
                        font.pointSize: fontSize
                        ColumnLayout{
                            anchors.fill: parent
                            MyListView {
                                id: m_RectView
                                width: parent.width
                                height: labelViewHeight
                                Connections {
                                    target: m_RectView
                                    onIndexChange:{
                                        mainview.selectOne(index,labelname)
                                    }
                                }
                                Connections {
                                    target: m_RectView
                                    onIn_deleteOneLabel:{
                                        mainview.deleteOneGraph(index)
                                    }
                                }
                            }
                        }
                    }
                    GroupBox{
                        title: qsTr("文件列表")
                        width: parent.width
                        height: fileViewHeight
                        font.pointSize: fontSize
                        ColumnLayout{
                            anchors.fill: parent
                            anchors.top: parent.top
                            ListView {
                                id: m_FileView
                                width: parent.width
                                height: fileViewHeight

                                model: FolderListModel{
                                    id:folderList;
                                    property var folders:[];
                                    folder:""
                                    nameFilters: ["*.bmp","*.jpg","*.png"];//要展示的文件后缀
                                    showDirs:false
                                    sortField:FolderListModel.Name
                                    sortReversed: false
                                }
                                onCurrentItemChanged: {
                                    var curPath =getCurrentImagePath()
                                    m_RectView.clearAll()
                                    mainview.openImage(curPath)
                                }
                                function getCurrentImagePath(){
                                    var p = folderList.get(currentIndex,"fileURL")
                                    return p
                                }

                                delegate: Rectangle {
                                    width: ListView.view.width
                                    height: 20
                                    color: ListView.isCurrentItem?"darkgray":"white" //选中颜色设置
                                    border.color: Qt.lighter(color, 1.1)
                                    Text{
                                        id:wrapper;
                                        text: filePath
                                        font.pointSize: 11
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            m_FileView.currentIndex = index  //实现item切换
                                            //ckBox.checked = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Text{
            id:stateText
            width: parent.width
            height: 30
            font.pointSize: fontSize
            text: "pos:0,0"
        }
    }
}
