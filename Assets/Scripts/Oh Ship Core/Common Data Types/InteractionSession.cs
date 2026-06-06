using System;
using System.Collections.Generic;

/// <summary>
/// Represents an ongoing interaction between an <see cref="IInteractor"/> and an <see cref="IInteractable"/>
/// </summary>
public class InteractionSession
{
    readonly Dictionary<Type, Delegate> m_events = new();
    /// <summary>
    /// Subscribes a handler to an event on the event bus for this <see cref="InteractionSession"/>
    /// </summary>
    /// <param name="handler">The <see cref="Action"/> to add to the handler</param>
    /// <typeparam name="T">The <see cref="Type"/> that this action returns</typeparam>
    public void Subscribe<T>(Action<T> handler)
    {
        Type key = typeof(T);
        if (m_events.TryGetValue(key, out Delegate existing)) m_events[key] = Delegate.Combine(existing, handler);
        else m_events[key] = handler;
    }
    /// <summary>
    /// Unsubscribes a handler from an event on the event bus for this <see cref="InteractionSession"/>
    /// </summary>
    /// <param name="handler">The <see cref="Action"/> to remove from the found handler</param>
    /// <typeparam name="T">The <see cref="Type"/> that this action returns</typeparam>
    public void Unsubscribe<T>(Action<T> handler)
    {
        Type key = typeof(T);
        if (!m_events.TryGetValue(key, out Delegate existing)) return;
        Delegate updated = Delegate.Remove(existing, handler);
        if (updated is null) m_events.Remove(key);
        else m_events[key] = updated;
    }
    /// <summary>
    /// Publishes an event on the event bus for this <see cref="InteractionSession"/> to all subscribers.
    /// </summary>
    /// <param name="payload">The payload to invoke the event with</param>
    /// <typeparam name="T">The <see cref="Type"/> that this action should invoke with</typeparam>
    public void Publish<T>(T payload)
    {
        if (m_events.TryGetValue(typeof(T), out Delegate handler)) ((Action<T>)handler).Invoke(payload);
    }
    /// <summary>
    /// The <see cref="IInteractor"/> that is currently interacting with the <see cref="Target"/>
    /// </summary>
    public IInteractor CurrentInteractor { get; private set; }
    /// <summary>
    /// The <see cref="IInteractable"/> that is being interacted with.
    /// </summary>
    public IInteractable Target { get; private set; }
    /// <summary>
    /// Whether the interaction session is still active.
    /// </summary>
    public bool IsActive { get; private set; }
    /// <summary>
    /// Invoked when the <see cref="InteractionSession"/> ends.
    /// </summary>
    public event Action OnEnded;
    /// <summary>
    /// Invoked when the <see cref="InteractionSession"/> is transferred to a new <see cref="IInteractor"/>. First parameter is the old <see cref="IInteractor"/>, second parameter is the new <see cref="IInteractor"/>
    /// </summary>
    public event Action<IInteractor, IInteractor> OnTransferred;
    /// <summary>
    /// Creates a new <see cref="InteractionSession"/>
    /// </summary>
    /// <param name="interactor">The <see cref="IInteractor"/> doing the interaction</param>
    /// <param name="target">The target <see cref="IInteractable"/> for the session</param>
    public InteractionSession(IInteractor interactor, IInteractable target)
    {
        CurrentInteractor =interactor;
        Target = target;
        IsActive = true;
    }
    /// <summary>
    /// Transfers the interaction session to a new <see cref="IInteractor"/>
    /// </summary>
    /// <param name="newInteractor">The <see cref="IInteractor"/> to transfer ownership to</param>
    public bool TransferTo(IInteractor newInteractor)
    {
        if (!IsActive || newInteractor is null) return false;
        IInteractor old = CurrentInteractor;
        CurrentInteractor = newInteractor;
        OnTransferred?.Invoke(old, newInteractor);
        return true;
    }
    /// <summary>
    /// Ends the <see cref="InteractionSession"/>
    /// </summary>
    public void End()
    {
        if (!IsActive) return;
        IsActive = false;
        OnEnded?.Invoke();
        OnEnded = null;
        OnTransferred = null;
    }
    
}