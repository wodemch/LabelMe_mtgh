#include "iniparams.h"
#include <QSettings>
#include <QDebug>
#include<QCoreApplication>
#include<QQmlEngine>
#include<QQmlContext>
IniParams::IniParams(QObject *parent) : QObject(parent)
{
    mfileName = QCoreApplication::applicationDirPath() +"/BasicParam.ini";
    readIni();
    view = new QQuickView();
    view->setSource(QUrl("qrc:/MymodifyParam.qml"));
    view->engine()->rootContext()->setContextProperty("gg",this);
    //view->setFlag(Qt::WindowMinMaxButtonsHint);
    view->setMinimumSize(QSize(500,300));
    view->setMaximumSize(QSize(500,300));
    view->setModality(Qt::WindowModality::ApplicationModal);
}
bool IniParams::readIni()
{
    QSettings settings(mfileName,QSettings::IniFormat);
    settings.beginGroup("Basic");
    mParams.PixSize = settings.value("PixSize",QSize(5000,5000)).toSize();
    mParams.AutoSave = settings.value("AutoSave",true).toBool();
    mParams.SaveFormt = settings.value("SaveFormt",0).toInt();
    mParams.LineWidth = settings.value("LineWidth",1).toInt();
    mParams.LineColor = settings.value("LineColor","red").toString();
    settings.endGroup();
    settings.sync();
    saveIni();
    return true;
}
bool IniParams::saveIni()
{
    QSettings settings(mfileName,QSettings::IniFormat);
    settings.beginGroup("Basic");
    settings.setValue("PixSize",mParams.PixSize);
    settings.setValue("AutoSave",mParams.AutoSave);
    settings.setValue("SaveFormt",mParams.SaveFormt);
    settings.setValue("LineWidth",mParams.LineWidth);
    settings.setValue("LineColor",mParams.LineColor);
    settings.endGroup();
    //settings.sync();
    return true;
}
void IniParams::showModify()
{
    view->show();
    mParamsEdit = mParams;
}

void IniParams::updataParams()
{
    mParams = mParamsEdit;
    emit ParamsChange();
    view->close();
    saveIni();
}
