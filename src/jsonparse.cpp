#include "jsonparse.h"
#include <QDebug>
#include<QFile>
#include<QJsonArray>
#include<QJsonObject>
#include<QJsonDocument>
jsonParse::jsonParse()
{

}
bool jsonParse::writeJson(QSize imgSize,const QString filepath,const QVector<CGraph>& vGraph)
{
    if(filepath=="")return true;

    mjsonFile = filepath.left(filepath.length()-3)+"json";
    if(vGraph.size()==0)
    {
        QFile labelfile(mjsonFile);
        if(labelfile.exists()){
            labelfile.close();
            labelfile.remove();
        }
        return true;
    }
    mAllGraph = vGraph;
    mImgSize = imgSize;
    return saveJson_0();//jsonSaveFormt==0?saveJson_0():saveJson_1();
}

QVector<CGraph> jsonParse::readJson(const QString filepath)
{
    QVector<CGraph> vGraph;
    vGraph.clear();
    if(filepath=="")return vGraph;

    mjsonFile = filepath.left(filepath.length()-3)+"json";

    QFile labelfile(mjsonFile);
    if(!labelfile.exists()){return vGraph;}
    if(!labelfile.open(QIODevice::ReadOnly)){
        qDebug()<<"some error when read the file"<<endl;
        return vGraph;
    }
    QByteArray allData=labelfile.readAll();
    QJsonParseError jsonError;
    QJsonDocument jsonDoc(QJsonDocument::fromJson(allData,&jsonError));

    if(jsonError.error!=QJsonParseError::NoError){
        qDebug()<<"json parse error"<<endl;
        return vGraph;
    }
    if(jsonDoc.isNull()||jsonDoc.isEmpty()){return vGraph;}
    QVariant dataList=jsonDoc.toVariant();

    //解析json文件
    QVariantMap dataMap=dataList.toMap();
    //int width=dataMap.value("width").toInt();
    //int height=dataMap.value("height").toInt();
    QVariantList vaList=dataMap.value("va").toList();

    foreach(QVariant data,vaList){
        CGraph aph;
        aph.ImgScale=1;
        QVariantMap va=data.toMap();
        aph.labelName=va.value("label").toString();
        //aph.labelName=va.value("pos").toInt();
        //aph.labelName=va.value("width").toInt();
        aph.Type=(EGraphType)va.value("type").toInt();

        QVariantList pointsList=va.value("pts").toList();

        QVector<QPoint> tempPt;
        foreach(QVariant pt,pointsList){
            QVariantMap va=pt.toMap();
            QPoint point;
            point.setX(va.value("x").toInt());
            point.setY(va.value("y").toInt());

            tempPt.push_back(point);
        }
        if(pointsList.size()<=4){
            aph.ChangeTwoPoint(tempPt);
        }else
        {
            aph.Type=EG_POLYGON;
        }
        foreach(QPoint p,tempPt){
            aph.addPoint(p);
        }
        vGraph.push_back(aph);
    }
    return vGraph;
}


bool jsonParse::saveJson_0()
{
    bool res = true;
    //形成json格式
    QFile labelfile(mjsonFile);
    QJsonObject jsonObj;
    QJsonArray va;
    foreach(CGraph shape,mAllGraph){
        QJsonObject obj;
        QJsonArray pts;
        foreach(QPoint p,shape.allPoint(true)){
            QJsonObject a;
            a.insert("x",p.x());
            a.insert("y",p.y());
            pts.append(a);
        }
        obj.insert("label",shape.labelName);
        obj.insert("pts",pts);
        obj.insert("pos",1);
        obj.insert("type",shape.Type);
        obj.insert("width",shape.getRect(true).width());

        va.append(obj);
    }
    jsonObj.insert("va",va);
    jsonObj.insert("width",mImgSize.width());
    jsonObj.insert("height",mImgSize.height());

    //写入文件
    QJsonDocument doc(jsonObj);
    QByteArray ba=doc.toJson(QJsonDocument::Compact);
    if(!labelfile.open(QIODevice::WriteOnly)){
        qDebug()<<"file write error"<<endl;
        res = false;
    }
    labelfile.write(ba);
    labelfile.close();
    return res;
}

bool jsonParse::saveJson_1()
{
    return true;
}
