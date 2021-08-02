#ifndef CGRAPH_H
#define CGRAPH_H
#include<QVector>
#include<QPoint>
#include<QRect>
#define POLYGON_MERGE_POINT 20
enum EGraphType{
    EG_RECT=0,
    EG_POLYGON,
    EG_CIRCLE
};
class CGraph
{
public:
    CGraph();
public:

    bool IsSelect;
    float ImgScale;
    EGraphType Type;    
    QString labelName;

    bool addPoint(QPoint point);
    void deletePoint();//delete last point

    bool isDrawing(){return bDrawing;}
    QVector<QPoint> allPoint(bool inImg=false);
    QRect getRect(bool inImg=false);
    void reset()
    {
        bDrawing = false;
        mVPoints.clear();
        mVImagePoints.clear();
    }
    //将四点矩形 转换为二点
    void ChangeTwoPoint(QVector<QPoint>& vp);
    //point in graph ?
    bool HavePoint(QPoint point);
private:
    bool bDrawing;
    QVector<QPoint> mVPoints;
    QVector<QPoint> mVImagePoints;

    bool PointCoincide();
    QPoint PointToImage(QPoint Point);
};

#endif // CGRAPH_H
