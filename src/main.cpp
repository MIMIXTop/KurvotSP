#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWaylandXdgSurface>
#include <cstdlib>
#include <qqml.h>

#include "Clock.hpp"
#include "ConfigManager.hpp"
#include "ProcessManager.hpp"
#include "compositormodel.hpp"
#include "loger.hpp"

int main(int argc, char *argv[]) {
  Loger::log("Starting Wayland Compositor application");
  // ОСНОВНЫЕ Wayland переменные
  setenv("XDG_SESSION_TYPE", "wayland", 1);
  setenv("XDG_CURRENT_DESKTOP", "appTemplateWaylandCompositor", 1);
  setenv("_JAVA_AWT_WM_NONREPARENTING", "1", 1);
  setenv("MOZ_ENABLE_WAYLAND", "1", 1);
  // setenv("QT_QPA_PLATFORM", "wayland", 1);
  setenv("XDG_SESSION_TYPE", "wayland", 1);

  // ГРАФИЧЕСКИЕ настройки для Intel
  // setenv("MESA_LOADER_DRIVER_OVERRIDE", "iris", 1);
  // setenv("EGL_PLATFORM", "wayland", 1);
  // setenv("GBM_BACKEND", "nouveau", 1);
  // setenv("QT_LOGGING_RULES", "qt.wayland.compositor.debug=false", 1);
  // setenv("QT_OPENGL", "software", 1);

  // Отключить проблемные функции
  unsetenv("DISPLAY");
  unsetenv("WAYLAND_DISPLAY");
  unsetenv("EGL_EXT_wayland_threads");

  // Для GTK4 приложений
  setenv("GDK_BACKEND", "wayland", 1);

  // Для NVIDIA (если есть гибридная графика)
  setenv("__NV_PRIME_RENDER_OFFLOAD", "1", 1);
  setenv("__GLX_VENDOR_LIBRARY_NAME", "nvidia", 1);
  setenv("__NV_DISABLE_EXPLICIT_SYNC", "1", 1);
  QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts, true);
  QGuiApplication app(argc, argv);

  qRegisterMetaType<QWaylandXdgSurface *>("QWaylandXdgSurface*");
  qmlRegisterType<ProcessManager>("Launcher", 1, 0, "Launcher");
  qmlRegisterType<CompositorModel>("MyModel", 1, 0, "MyModel");
  qmlRegisterType<Clock>("Clock", 1, 0, "Clock");
  qmlRegisterType<ConfigManager>("ConfigManager", 1, 0, "ConfigManager");

  QQmlApplicationEngine engine(QUrl("qrc:///src/QmlSource/Main.qml"));

  return app.exec();
}
