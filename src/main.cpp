#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWaylandXdgSurface>
#include <qqml.h>

#include "Clock.hpp"
#include "ProcessManager.hpp"
#include "compositormodel.hpp"
#include "loger.hpp"

int main(int argc, char *argv[]) {
  Loger::log("Starting Wayland Compositor application");

  QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts, true);
  QGuiApplication app(argc, argv);

  qRegisterMetaType<QWaylandXdgSurface *>("QWaylandXdgSurface*");
  qmlRegisterType<ProcessManager>("Launcher", 1, 0, "Launcher");
  qmlRegisterType<CompositorModel>("MyModel", 1, 0, "MyModel");
  qmlRegisterType<Clock>("Clock", 1, 0, "Clock");

  QQmlApplicationEngine engine(QUrl("qrc:///src/QmlSource/Main.qml"));

  return app.exec();
}
