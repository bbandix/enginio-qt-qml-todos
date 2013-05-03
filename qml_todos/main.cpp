#include <QtGui/QGuiApplication>
#include <QDir>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    QDir qmlImportDir(ROOT_BUILD_DIR);
    qmlImportDir.cd("../enginio-qt/qml");
    viewer.addImportPath(qmlImportDir.canonicalPath());
    viewer.setMainQmlFile(QStringLiteral("qml/todos/main.qml"));
    viewer.setTitle(QStringLiteral("Enginio Todos"));
    viewer.showExpanded();

    return app.exec();
}
