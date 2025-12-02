#include "Clock.hpp"

#include <QMap>
#include <QTimer>

namespace {
QMap<QString, QString> months = {
    {"01", "январь"},   {"02", "февраль"}, {"03", "март"},   {"04", "апрель"},
    {"05", "май"},      {"06", "июнь"},    {"07", "июль"},   {"08", "август"},
    {"09", "сентябрь"}, {"10", "октябрь"}, {"11", "ноябрь"}, {"12", "декабрь"}};
};

Clock::Clock(QObject *parent) : QObject(parent) {
  QTimer *timer = new QTimer(this);
  connect(timer, &QTimer::timeout, this, &Clock::updateTime);
  timer->start(1000);

  updateDate();
}

QString Clock::time() const {
    return m_time == "" ? QTime::currentTime().toString("hh:mm") : m_time;
}

void Clock::updateTime() {
  m_time = QDateTime::currentDateTime().toString("hh:mm");
  emit timeChanged();
  if (m_time == "00:00") {
    updateDate();
  }
}

void Clock::updateDate() {
  m_date = QDateTime::currentDateTime().toString("dd.MM");
  m_date = months[m_date.mid(3, 2)] + " " + m_date.mid(0, 2);
  emit dateChanged();
}
