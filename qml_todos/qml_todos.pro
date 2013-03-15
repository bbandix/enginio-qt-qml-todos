# Add more folders to ship with the application, here
todos.source = qml/todos
todos.target = qml
DEPLOYMENTFOLDERS = todos

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH = $$OUT_PWD/../enginio-qt/enginio_plugin/

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../enginio-qt/enginio_client/release/ -lenginioclient
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../enginio-qt/enginio_client/debug/ -lenginioclient
else:unix: LIBS += -L$$OUT_PWD/../enginio-qt/enginio_client/ -lenginioclient

INCLUDEPATH += $$PWD/../enginio-qt/enginio_client
DEPENDPATH += $$PWD/../enginio-qt/enginio_client
