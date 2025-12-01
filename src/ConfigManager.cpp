#include "ConfigManager.hpp"
#include "loger.hpp"
#include <QDir>
#include <QFileInfo>

ConfigManager::ConfigManager(QObject *parent) : QObject(parent) {
  m_watcher = new QFileSystemWatcher(this);
  connect(m_watcher, &QFileSystemWatcher::fileChanged, this,
          &ConfigManager::onFileChanged);

  loadConfig();

  // Watch the user config if it exists (only filesystem paths can be watched)
  if (!m_configPath.startsWith("qrc:") && QFile::exists(m_configPath)) {
    m_watcher->addPath(m_configPath);
    Loger::log("Watching config file: " + m_configPath.toStdString());
  }
}

void ConfigManager::onFileChanged(const QString &path) {
  Loger::log("Config file changed: " + path.toStdString());
  qInfo() << "Config file changed:" << path;
  // Re-add the path if it was deleted/recreated (common with some editors)
  if (!m_watcher->files().contains(path) && QFile::exists(path)) {
    m_watcher->addPath(path);
  }
  loadConfig();
}

void ConfigManager::loadConfig() {
  QStringList configPaths = {"compositor.conf",
                             QDir::homePath() + "/.config/compositor.conf",
                             "/home/mimixtop/Projects/FutureKurvot/"
                             "TemplateWaylandCompositor/compositor.conf"};

  m_configPath.clear();
  QFile file;

  for (const QString &path : configPaths) {
    file.setFileName(path);
    if (file.exists()) {
      m_configPath = path;
      Loger::log("Found config at: " + path.toStdString());
      break;
    }
  }

  if (m_configPath.isEmpty()) {
    Loger::log("No config file found, using defaults");
    qWarning() << "No compositor.conf found";
    return;
  }

  if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    Loger::log("Failed to open " + m_configPath.toStdString());
    qWarning() << "Failed to open" << m_configPath;
    return;
  }

  m_config.clear(); // Clear old config

  QTextStream in(&file);
  while (!in.atEnd()) {
    QString line = in.readLine().trimmed();
    if (line.isEmpty() || line.startsWith("#"))
      continue;

    QStringList parts = line.split("=");
    if (parts.size() >= 2) {
      QString key = parts[0].trimmed();
      QString value = parts.mid(1).join("=").trimmed(); // Handle values with =
      m_config[key] = value;
      Loger::log("Config: " + key.toStdString() + " = " + value.toStdString());
    }
  }
  file.close();

  emit configChanged();
  Loger::log("Configuration reloaded from: " + m_configPath.toStdString());
}
