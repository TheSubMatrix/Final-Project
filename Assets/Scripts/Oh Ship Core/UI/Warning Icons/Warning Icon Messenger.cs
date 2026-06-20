using System;
using System.Collections;
using System.Collections.Generic;
using JetBrains.Annotations;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class WarningIconMessenger : MonoBehaviour, INotificationMessenger, IDependencyProvider
{
    [Provide, UsedImplicitly] INotificationMessenger Provide() => this;
    readonly Dictionary<string, Action> m_notificationSubscriptions = new();
    public bool TrySubscribe(string id, Action notification)
    {
        Action existingNotification = m_notificationSubscriptions.GetValueOrDefault(id);
        existingNotification += notification;
        m_notificationSubscriptions[id] = existingNotification;
        return true;
    }

    public bool TryUnsubscribe(string id, Action notification)
    {
        if(!m_notificationSubscriptions.TryGetValue(id, out Action found)) return false;
        found -= notification;
        m_notificationSubscriptions[id] = found;
        return true;
    }

    public bool TryNotify(string id)
    {
        if(!m_notificationSubscriptions.TryGetValue(id, out Action found)) return false;
        found();
        return true;
    }
}