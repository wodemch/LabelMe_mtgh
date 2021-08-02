#ifndef JSONPARSE_H
#define JSONPARSE_H

#include<cgraph.h>

class jsonParse
{
public:
    jsonParse();

    int jsonSaveFormt;
    //filepath xxx.jpg xxx.bmp xxx.png
    QVector<CGraph> readJson(const QString filepath);
    bool writeJson(QSize imgSize,const QString filepath,const QVector<CGraph>& vGraph);

private:
    bool saveJson_0();
    bool saveJson_1();
    QString mjsonFile;
    QSize mImgSize;
    QVector<CGraph> mAllGraph;
};

#endif // JSONPARSE_H
