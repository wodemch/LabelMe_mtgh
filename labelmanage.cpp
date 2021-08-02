#include "labelmanage.h"
#include<QDebug>
#include <QFile>
LabelManage::LabelManage(QObject *parent) : QObject(parent)
{

}

void LabelManage::testSlot(QString str)
{
    qDebug()<<"test slot:"<<str;
}

void LabelManage::DeleteFile(QUrl str)
{
     QFile file(str.toLocalFile());
     file.remove();
}
