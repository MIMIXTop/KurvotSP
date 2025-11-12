#include "compositormodel.hpp"
#include <QVariant>
#include <QList>


CompositorModel::CompositorModel(QObject *parent) : QAbstractListModel(parent) {}

int CompositorModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent);
    return m_surfaces.size();
}

QVariant CompositorModel::data(const QModelIndex &index, int role) const {
    if (index.row() < 0 || index.row() >= m_surfaces.size()) {
        return QVariant();
    }
    if (m_surfaces.size() > 1) {
        switch (index.row())
        {
        case 1: return QVariant();        
        default: return QVariant::fromValue(m_surfaces[index.row()]);
        }
    }
    return QVariant::fromValue(m_surfaces[index.row()]);
}

void CompositorModel::append(QWaylandXdgSurface* surface) {
    beginInsertRows(QModelIndex(), m_surfaces.size(), m_surfaces.size());
    m_surfaces.append(surface);
    endInsertRows();
    emit countChanged();
}

void CompositorModel::remove(int index) {
    beginRemoveRows({}, index, index);
    m_surfaces.removeAt(index);
    endRemoveRows();
}

QVariantList CompositorModel::allButFirst() const {
    QVariantList res;
    if (m_surfaces.size() <= 1)
        return res;

    for (auto it = m_surfaces.cbegin() + 1; it != m_surfaces.cend(); ++it) {
        res << QVariant::fromValue(*it);
    }
    return res;
}

QVariantList CompositorModel::first() const {
    QVariantList res;
    auto it = m_surfaces.cbegin();
    res << QVariant::fromValue(*it);
    return res;
}


QWaylandXdgSurface *CompositorModel::at(int index) const {
    return index >= 0 && index < m_surfaces.size() ? m_surfaces.at(index) : nullptr;
}
