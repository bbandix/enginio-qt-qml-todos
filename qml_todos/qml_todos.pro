include($$PWD/../enginio-qt/enginio.pri)

# Add more folders to ship with the application, here
todos.source = qml/todos
todos.target = qml
DEPLOYMENTFOLDERS = todos

DEFINES += ROOT_BUILD_DIR=\\\"$$OUT_PWD\\\"

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()
