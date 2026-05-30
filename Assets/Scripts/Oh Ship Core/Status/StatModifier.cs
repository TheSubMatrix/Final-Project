using System;
/// <summary>
/// Represents a modification to a stat in a <see cref="StatBlock"/>. Primarily handled by the <see cref="StatBroker"/>.
/// </summary>
public abstract class StatModifier : IDisposable
{
    /// <summary>
    /// Whether the <see cref="StatModifier"/> has been marked for removal during the next update cycle
    /// </summary>
    public bool MarkedForRemoval { get; private set; }
    /// <summary>
    /// A <see cref="Action"/> invoked when the <see cref="StatModifier"/> is disposed.
    /// </summary>
    public event Action<StatModifier> OnDisposed = delegate { };
    /// <summary>
    /// Updates the <see cref="StatModifier"/>
    /// </summary>
    /// <param name="deltaTime">The time since the last update cycle</param>
    public abstract void Update(float deltaTime);
    /// <summary>
    /// Handles any incoming <see cref="StatQuery"/>
    /// </summary>
    /// <param name="sender">The <see cref="object"/> that made this <see cref="StatQuery"/></param>
    /// <param name="query">The <see cref="StatQuery"/> to possibly apply a modification to</param>
    public abstract void Handle(object sender, StatQuery query);
    /// <summary>
    /// Disposes of the <see cref="StatModifier"/>
    /// </summary>
    public void Dispose()
    {
        if (MarkedForRemoval) return;
        MarkedForRemoval = true;
        OnDisposed(this);
    }
}