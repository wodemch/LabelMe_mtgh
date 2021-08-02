#include "cgraph.h"
#include<QRect>
#include<QPolygon>
#include<QDebug>
CGraph::CGraph()
{
    Type = EG_RECT;
    IsSelect = false;
    bDrawing = false;
    ImgScale = 1;
    labelName="";
}

bool CGraph::addPoint(QPoint point)
{
    switch (Type){
    case EG_RECT:
        if(mVPoints.size()<2){
            mVPoints.push_back(point);
            bDrawing = mVPoints.size()<2;
        }else {
            bDrawing = false;
        }
        break;
    case EG_POLYGON:
        mVPoints.push_back(point);
        bDrawing = !PointCoincide();
        break;
    case EG_CIRCLE:
        if(mVPoints.size()<2){
            mVPoints.push_back(point);
            bDrawing = mVPoints.size()<2;
        }else{
            bDrawing = false;
        }
        break;
    }
    //绘制结束 转换图像坐标
    if(!bDrawing){
        mVImagePoints.clear();

        for(QPoint p:mVPoints)
        {
            mVImagePoints.push_back(PointToImage(p));
        }
        if(Type == EG_RECT)
        {
            std::sort(mVImagePoints.begin(),mVImagePoints.end(),[](const QPoint& a,const QPoint& b){
                return a.x()<b.x();
            });
            QVector<QPoint> vtemp = mVImagePoints;
            mVImagePoints.clear();
            mVImagePoints.push_back(vtemp[0]);
            mVImagePoints.push_back(QPoint(vtemp[0].x(),vtemp[1].y()));
            mVImagePoints.push_back(vtemp[1]);
            mVImagePoints.push_back(QPoint(vtemp[1].x(),vtemp[0].y()));
        }
    }
    return !bDrawing;
}
//delete last point
void CGraph::deletePoint()
{
    switch (Type){
    case EG_RECT:
        if(mVPoints.size()>0){
            mVPoints.pop_back();
        }
        break;
    case EG_POLYGON:
        if(mVPoints.size()>0){
            mVPoints.pop_back();
        }
        break;
    case EG_CIRCLE:
        if(mVPoints.size()>0){
            mVPoints.pop_back();
        }
        break;
    }
    bDrawing = mVPoints.size()>0;
}

bool CGraph::PointCoincide()
{
    if(mVPoints.size()<3)
    {
        return false;
    }
    QPoint startP = mVPoints.first();
    QPoint endP = mVPoints.last();
    QRect rect(startP.x()-POLYGON_MERGE_POINT,startP.y()-POLYGON_MERGE_POINT,2*POLYGON_MERGE_POINT,2*POLYGON_MERGE_POINT);

    //qDebug()<<QString("PointCoincide:rect:%1,%2,%3,%4,point:%5,%6").
              //arg(rect.x()).arg(rect.y()).arg(rect.width()).arg(rect.height()).arg(endP.x()).arg(endP.y());
    if(rect.contains(endP))
    {
        if(mVPoints.last()!=mVPoints.first())
            mVPoints.push_back(mVPoints.first());
        return true;
    }
    return false;
}
QPoint CGraph::PointToImage(QPoint Point)
{
    QPoint p;
    p.setX(Point.x()/ImgScale);
    p.setY(Point.y()/ImgScale);
    return p;
}
QVector<QPoint> CGraph::allPoint(bool inImg)
{
    if(inImg)
        return mVImagePoints;
    else
        return mVPoints;
}
QRect CGraph::getRect(bool inImg)
{
    QRect rect =QRect(0,0,0,0);
    if(mVPoints.size()<2)return rect;
    switch (Type){
    case EG_RECT:
        if(inImg){
            rect = QRect(mVImagePoints[0],mVImagePoints[2]);
        }else{
            rect = QRect(mVPoints[0],mVPoints[1]);
        }
        break;
    case EG_CIRCLE:
        if(inImg){
            rect = QRect(mVImagePoints[0],mVImagePoints[1]);
        }else{
            rect = QRect(mVPoints[0],mVPoints[1]);
        }
        break;
    case EG_POLYGON:
        QPolygon polygon;
        if(inImg){
            polygon= QPolygon(mVImagePoints);
        }else{
            polygon= QPolygon(mVPoints);
        }
        rect = polygon.boundingRect();
        break;
    }
    return rect;
}
bool CGraph::HavePoint(QPoint point)
{
    return getRect().contains(point);
}
void CGraph::ChangeTwoPoint(QVector<QPoint>& vp)
{
    if(Type!=EG_RECT)return;
    int minx=99999,miny=99999,maxx=0,maxy=0;
    foreach(QPoint p,vp)
    {
        minx = p.x()<minx?p.x():minx;
        miny = p.y()<miny?p.y():miny;
        maxx = p.x()>maxx?p.x():maxx;
        maxy = p.y()>maxy?p.y():maxy;
    }
    vp.clear();
    vp.push_back(QPoint(minx,miny));
    vp.push_back(QPoint(maxx,maxy));
}
