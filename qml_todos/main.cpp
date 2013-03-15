#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.addImportPath("../enginio-qt/enginio_plugin/");
    viewer.setMainQmlFile(QStringLiteral("qml/todos/main.qml"));
    viewer.setTitle(QStringLiteral("Enginio Todos"));
    viewer.showExpanded();

    return app.exec();
}
