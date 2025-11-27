#pragma once

#include <QDateTime>
#include <QObject>

class Clock : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString time READ time NOTIFY timeChanged)
  Q_PROPERTY(QString date READ date NOTIFY dateChanged)
public:
  Clock(QObject *parent = nullptr);

  QString time() const {
    return m_time == "" ? QTime::currentTime().toString("hh:mm") : m_time;
  }
  QString date() const { return m_date; }

signals:
  void timeChanged();
  void dateChanged();

private slots:
  void updateTime();
  void updateDate();

private:
  QString m_time = "";
  QString m_date = "";
};