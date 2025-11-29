#include "compositormodel.hpp"
#include <QList>
#include <QVariant>

CompositorModel::CompositorModel(QObject *parent)
    : QAbstractListModel(parent) {}

int CompositorModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent);
  return m_surfaces.size();
}

QHash<int, QByteArray> CompositorModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[ShellSurfaceRole] = "shellSurface";
  return roles;
}

QVariant CompositorModel::data(const QModelIndex &index, int role) const {
  if (index.row() < 0 || index.row() >= m_surfaces.size()) {
    return QVariant();
  }
  if (role == ShellSurfaceRole) {
    return QVariant::fromValue(m_surfaces[index.row()]);
  }
  return QVariant::fromValue(m_surfaces[index.row()]);
}

void CompositorModel::append(QWaylandXdgSurface *surface) {
  beginInsertRows(QModelIndex(), m_surfaces.size(), m_surfaces.size());
  m_surfaces.append(surface);
  endInsertRows();
  emit countChanged();
  emit requestActivate(surface);
}

void CompositorModel::remove(int index) {
  beginRemoveRows({}, index, index);
  m_surfaces.removeAt(index);
  endRemoveRows();
}

void CompositorModel::activate(int index) {
  if (index >= 0 && index < m_surfaces.size()) {
    emit requestActivate(m_surfaces.at(index));
  }
}

QWaylandXdgSurface *CompositorModel::at(int index) const {
  return index >= 0 && index < m_surfaces.size() ? m_surfaces.at(index)
                                                 : nullptr;
}
