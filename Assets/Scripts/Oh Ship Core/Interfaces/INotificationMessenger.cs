using System;

public interface INotificationMessenger
{
    public bool TrySubscribe(string id, Action notification);
    public bool TryUnsubscribe(string id, Action notification);
    public bool TryNotify(string id);
}